require 'spec_helper'
require 'omniauth/version'


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
    b.use Rack::Session::Cookie, {secret: "abc123"}
    b.use OmniAuth::Strategies::Aai
    b.run lambda{|env| [200, {}, ['Hello World']]}
  end.to_app }


  # context 'core attributes' do
  #   let(:strategy){ OmniAuth::Strategies::Aai.new(app, {}) }

  #   it 'uses persistent-id as uid' do
  #     expect(OmniAuth::Strategies::Developer.new(app).uid).to eq('persistent_id')
  #   end
  # end

  context 'request phase' do
    before do
      get '/auth/aai'
    end

    it 'should redirect to callback_url' do
      expect(last_response.status).to eq(302)
      expect(last_response.location).to eq('/auth/aai/callback')
    end
  end

  context 'callback phase' do

    context 'without Shibboleth session' do
      before do
        get '/auth/aai/callback'
      end

      it 'is expected to fail to get Shib-Session-ID environment variable' do
        expect(last_response.status).to eq(302)
        expect(last_response.location).to eq(failure_path)
      end

    end

    context 'with Shibboleth session' do
      let(:strategy){ OmniAuth::Strategies::Aai.new(app, {}) }

      before do
        @dummy_id = 'abcdefg'
        @uid = 'https://aai-logon.vho-switchaai.ch/idp/shibboleth!https://aai-viewer.switch.ch/shibboleth!lYQnHiuZjROvtykBpZHjy1UaZPg='
        @last_name = 'Nachname'
        @first_name = 'Vorname'
        @display_name = "#{@first_name} #{@last_name}"
        @email = 'test@example.com'
        @shibboleth_unique_id = '099886@vho-switchaai.ch'
        @home = 'switch.ch'
        env = make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'persistent-id' => @uid, 'surname' => @last_name, 'first_name' => @first_name, 'displayName' => @display_name, 'mail' => @email, 'uniqueID' => @shibboleth_unique_id, 'homeOrganization' => @home)
        response = strategy.call!(env)
      end

      it 'is expected to set the provider field' do
        expect(strategy.env['omniauth.auth']['provider']).to eq('aai')
      end

      it 'is expected to set the uid to persistent-id' do
        expect(strategy.env['omniauth.auth']['uid']).to eq(@uid)
      end

      context 'info fields' do
        it 'is expected to set the required name field to the displayName' do
          expect(strategy.env['omniauth.auth']['info']['name']).to eq("#{@first_name} #{@last_name}")
        end

        it 'is expected to set the mail field' do
          expect(strategy.env['omniauth.auth']['info']['email']).to eq(@email)
        end
      end

      context 'extra fields' do
        it 'is expected to set the home_organization field' do
          expect(strategy.env['omniauth.auth']['info']["home_organization"]).to eq(@home)
        end
      end

    end

    context 'with Shibboleth session and attribute options' do
      let(:options){
        {
          uid_field: :uniqueID,
          fields: [],
          extra_fields: [:"Shib-Authentication-Instant", :homeOrganization]
        }
      }
      let(:app){ lambda{|env| [404, {}, ['Awesome']]}}
      let(:strategy){ OmniAuth::Strategies::Aai.new(app, options) }

      it 'should set specified omniauth.auth fields' do
        @dummy_id = 'abcdefg'
        @uid = 'test'
        @home = 'Test Corporation'
        @instant = '2012-07-04T14:08:18.999Z'
        strategy.call!(make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'uniqueID' => @uid, 'Shib-Authentication-Instant' => @instant, 'homeOrganization' => @home))
        expect(strategy.env['omniauth.auth']['uid']).to eq(@uid)
        expect(strategy.env['omniauth.auth']['extra']['raw_info']['Shib-Authentication-Instant']).to eq(@instant)
        expect(strategy.env['omniauth.auth']['extra']['raw_info']['homeOrganization']).to eq(@home)
      end

      it 'can handle empty core attributes' do
        @dummy_id = 'abcdefg'
        @uid = 'test'
        @home = nil
        strategy.call!(make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'uniqueID' => @uid, 'Shib-Authentication-Instant' => @instant, 'homeOrganization' => @home))
        expect(strategy.env['omniauth.auth']['info']['homeOrganization']).to eq(@home)
      end
    end

    context 'with debug options' do
      let(:options){ { :debug => true} }
      let(:app){ lambda{|env| [404, {}, ['Not Found']]}}
      let(:strategy){ OmniAuth::Strategies::Aai.new(app, options) }

      it 'is expected to raise environment variables' do
        @dummy_id = 'abcdefg'
        @uid = 'https://aai-logon.vho-switchaai.ch/idp/shibboleth!https://aai-viewer.switch.ch/shibboleth!lYQnHiuZjROvtykBpZHjy1UaZPg='
        @last_name = 'Nachname'
        @first_name = 'Vorname'
        @email = 'test@example.com'
        env = make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'persistent-id' => @uid, 'surname' => @last_name, 'first_name' => @first_name, 'mail' => @email)
        response = strategy.call!(env)
        expect(response[0]).to eq(200)
      end

      # it 'should return the attributes' do
      #   @dummy_id = 'abcdefg'
      #   @uid = 'https://aai-logon.vho-switchaai.ch/idp/shibboleth!https://aai-viewer.switch.ch/shibboleth!lYQnHiuZjROvtykBpZHjy1UaZPg='
      #   @last_name = 'Nachname'
      #   @first_name = 'Vorname'
      #   @email = 'test@example.com'
      #   env = make_env('/auth/aai/callback', 'Shib-Session-ID' => @dummy_id, 'persistent-id' => @uid, 'surname' => @last_name, 'first_name' => @first_name, 'mail' => @email)
      #   response = strategy.call!(env)
      #   expect(response[2]).to include('surname')
      # end
    end
  end
end
