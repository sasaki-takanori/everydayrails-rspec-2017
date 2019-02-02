require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  include_context "project setup"

  describe "#show" do
    it "content_typeがJSON形式のレスポンスを返すこと" do
      sign_in user
      get :show, format: :json,
          params: { project_id: project.id, id: task.id }
      expect(response).to have_content_type :json
    end
  end

  describe "#create" do
    it "content_typeがJSON形式のレスポンスを返すこと" do
      new_task = { name: "New test task" }
      sign_in user
      post :create, format: :json,
           params: { project_id: project.id, task: new_task }
      expect(response).to have_content_type :json
    end

    it "新しいタスクをプロジェクトに追加すること" do
      new_task = { name: "New test task" }
      sign_in user
      expect {
        post :create, format: :json,
             params: { project_id: project.id, task: new_task }
      }.to change(project.tasks, :count).by(1)
    end

    it "認証を要求すること" do
      new_task = { name: "New test task" }
      # ここではあえてログインせずに失敗することをテストする
      expect {
        post :create, format: :json,
             params: { project_id: project.id, task: new_task }
      }.to_not change(project.tasks, :count)
      expect(response).to_not be_success
    end
  end
end
