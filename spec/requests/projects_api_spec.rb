require 'rails_helper'

describe 'Projects API', type: :request do
  context 'プロジェクト一覧を取得して' do
    it '1件のプロジェクトを読み出すこと' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project, name: "Sample Project")
      FactoryBot.create(:project, name: "Second Sample Project", owner: user)

      get api_projects_path, params: {
          user_email: user.email,
          user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      project_id = json[0]["id"]

      get api_project_path(project_id), params: {
          user_email: user.email,
          user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "Second Sample Project"
      # Etc.
    end
  end

  describe 'GET /api/projects' do
    it 'プロジェクト一覧を取得できること' do
      user = FactoryBot.create(:user)
      project1 = FactoryBot.create(:project, name: "First Sample Project", owner: user)
      project2 = FactoryBot.create(:project, name: "Second Sample Project", owner: user)
      get api_projects_path, params: {
          user_email: user.email,
          user_token: user.authentication_token
      }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).map { |p| p['name'] }).to eq [project1.name, project2.name]
    end
  end

  describe 'POST /api/projects' do
    it 'プロジェクトを作成できること' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project, name: "Sample Project")
      FactoryBot.create(:project, name: "Second Sample Project", owner: user)

      project_attributes = FactoryBot.attributes_for(:project)

      expect {
        post api_projects_path, params: {
            user_email: user.email,
            user_token: user.authentication_token,
            project: project_attributes
        }
      }.to change(user.projects, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/projects/:id' do
    it 'プロジェクト詳細を取得できること' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project, name: "Sample Project")
      user_project = FactoryBot.create(:project, name: "Second Sample Project", owner: user)
      get api_project_path(user_project.id), params: {
          user_email: user.email,
          user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['name']).to eq user_project.name
    end
  end

end
