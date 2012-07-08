require 'spec_helper'

def make_env(path = '/auth/aai', props = {})
  {
    'REQUEST_METHOD' => 'GET',
    'PATH_INFO' => path,
    'rack.session' => {},
    'rack.input' => StringIO.new('test=true')
  }.merge(props)
end

def failure_path
  if OmniAuth::VERSION >= "1.0" && OmniAuth::VERSION < "1.1"
    "/auth/failure?message=no_aai_session"
  elsif OmniAuth::VERSION >= "1.1"
    "/auth/failure?message=no_shibboleth_session&strategy=aai"
  end
end

describe OmniAuth::Strategies::Aai do
  let(:app){ Rack::Builder.new do |b|
    b.use Rack::Session::Cookie
    b.use OmniAuth::Strategies::Aai
    b.run lambda{|env| [200, {}, ['Not Found']]}
  end.to_app }

  context 'request phase' do
    before do
      get '/auth/aai'
    end

    it 'should redirect to callback_url' do
      last_response.status.should == 302
      last_response.location.should == '/auth/aai/callback'
    end
  end

  context 'callback phase' do
    context 'without Shibboleth session' do
      before do
        get '/auth/aai/callback'
      end

      it 'should fail to get Shib-Session-ID environment variable' do
        last_response.status.should == 302
        last_response.location.should == failure_path
      end
    end

    context 'with Shibboleth session' do
      let(:strategy){ OmniAuth::Strategies::Aai.new(app, {}) }
  
      it 'should set default omniauth.auth fields' do
        @dummy_id = 'abcdefg'
        @uid = 'https://aai-logon.vho-switchaai.ch/idp/shibboleth!https://aai-viewer.switch.ch/shibboleth!lYQnHiuZjROvtykBpZHjy1UaZPg='
        @last_name = 'Nachname'
        @first_name = 'Vorname'
        @email = 'test@example.com'
        @shibboleth_unique_id = '099886@vho-switchaai.ch'
        strategy.call!(make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'persistent-id' => @uid, 'surname' => @last_name, 'first_name' => @first_name, 'mail' => @email, 'Shib-SwissEP-UniqueID' => @shibboleth_unique_id))
        strategy.env['omniauth.auth']['uid'].should == @uid
        strategy.env['omniauth.auth']['info']['name'].should == "#{@first_name} #{@last_name}"
        strategy.env['omniauth.auth']['info']['email'].should == @email
        strategy.env['omniauth.auth']['info']['swiss_ep_uid'].should == @shibboleth_unique_id
      end
    end

    context 'with Shibboleth session and attribute options' do
      let(:options){ { :uid_field => :uniqueID, :fields => [], :extra_fields => [:"Shib-Authentication-Instant", :homeOrganization] } }
      let(:app){ lambda{|env| [404, {}, ['Awesome']]}}
      let(:strategy){ OmniAuth::Strategies::Aai.new(app, options) }

      it 'should set specified omniauth.auth fields' do
        @dummy_id = 'abcdefg'
        @uid = 'test'
        @home = 'Test Corporation'
        @instant = '2012-07-04T14:08:18.999Z'
        strategy.call!(make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'uniqueID' => @uid, 'Shib-Authentication-Instant' => @instant, 'homeOrganization' => @home))
        strategy.env['omniauth.auth']['uid'].should == @uid
        strategy.env['omniauth.auth']['extra']['raw_info']['Shib-Authentication-Instant'].should == @instant
        strategy.env['omniauth.auth']['extra']['raw_info']['homeOrganization'].should == @home
      end
    end

    context 'with debug options' do
      let(:options){ { :debug => true} }
      let(:strategy){ OmniAuth::Strategies::Shibboleth.new(app, options) }

      it 'should raise environment variables' do
        @dummy_id = 'abcdefg'
        @uid = 'https://aai-logon.vho-switchaai.ch/idp/shibboleth!https://aai-viewer.switch.ch/shibboleth!lYQnHiuZjROvtykBpZHjy1UaZPg='
        @last_name = 'Nachname'
        @first_name = 'Vorname'
        @email = 'test@example.com'
        env = make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'persistent-id' => @uid, 'surname' => @last_name, 'first_name' => @first_name, 'mail' => @email)
        response = strategy.call!(env)
        response[0].should == 200
      end
    end
  end
end