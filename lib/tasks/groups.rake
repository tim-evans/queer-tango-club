namespace :groups do
  desc "Attach pre-existing groups to Queer Tango Club"
  task :create => :environment do
    Group.transaction do
      qtc = Group.create(
        name: "Queer Tango Club",
        email: "info@queertangoclub.nyc",
        hostname: "queertangoclub.nyc"
      )
      puts "API KEY: #{qtc.api_key}"

      Attendee.all.update_all(group_id: qtc.id)
      Event.all.update_all(group_id: qtc.id)
      Location.all.update_all(group_id: qtc.id)
      Member.all.update_all(group_id: qtc.id)
      Teacher.all.update_all(group_id: qtc.id)
      Expense.all.update_all(group_id: qtc.id)
      User.all.update_all(group_id: qtc.id)
    end
  end
end
