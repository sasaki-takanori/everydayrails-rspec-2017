FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."
    due_on 1.week.from_now
    association :owner

    # メモ付きのプロジェクト
    trait :with_notes do
      # 変数として受け取りたい部分をtransientとして定義する
      # transientが渡されなかった場合のデフォルト値を設定する
      transient do
        note_count 5
      end
      # transientはevaluatorを使って呼び出す
      after(:create) do |project, evaluator|
        create_list(:note, evaluator.note_count, project: project)
      end
    end

    # 締切が昨日(締め切りを過ぎている)
    trait :due_yesterday do
      due_on 1.day.ago
    end

    # 締切が今日
    trait :due_today do
      due_on Date.current.in_time_zone
    end

    # 締切が明日
    trait :due_tomorrow do
      due_on 1.day.from_now
    end

    trait :invalid do
      name nil
    end

    # Factory inheritance examples ...
    #
    # factory :project_due_yesterday do
    #   due_on 1.day.ago
    # end
    #
    # factory :project_due_today do
    #   due_on Date.current.in_time_zone
    # end
    #
    # factory :project_due_tomorrow do
    #   due_on 1.day.from_now
    # end
  end

  # Non-DRY versions ...
  #
  # factory :project_due_yesterday, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on 1.day.ago
  #   association :owner
  # end
  #
  # factory :project_due_today, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on Date.today
  #   association :owner
  # end
  #
  # factory :project_due_tomorrow, class: Project do
  #   sequence(:name) { |n| "Test Project #{n}" }
  #   description "Sample project for testing purposes"
  #   due_on 1.day.from_now
  #   association :owner
  # end
end
