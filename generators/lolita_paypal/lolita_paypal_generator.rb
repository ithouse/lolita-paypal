class LolitaPaypalGenerator < Rails::Generator::Base
  def initialize(runtime_args, runtime_options = {})
    super
    usage if @args.first == "help"
  end

  def manifest
    record do |m|
      m.migration_template "paypal_transactions.erb", "db/migrate", :migration_file_name => "create_paypal_transactions"
    end
  end
end
