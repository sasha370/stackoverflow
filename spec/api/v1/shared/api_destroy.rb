shared_examples_for 'API Destroyable' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'with correct data' do
      it 'return 200 status' do
        do_request(method_name, api_path, params: {access_token: access_token.token}, headers: headers)
        expect(response).to be_successful
      end

      it 'delete question in DB' do
        expect { delete api_path, params: {access_token: access_token.token}, headers: headers }.to change(model, :count).by(-1)
      end
    end
end
