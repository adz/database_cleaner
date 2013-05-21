require 'active_record/base'
require 'active_record/connection_adapters/abstract_adapter'
require "database_cleaner/generic/truncation"
require 'database_cleaner/active_record/base'
require 'database_cleaner/active_record/truncation'

module DatabaseCleaner::ActiveRecord
  class Deletion < Truncation

    def clean
      connection = connection_class.connection
      connection.disable_referential_integrity do
        
        # HACK: MySql2 (for my project at least) seems to complain 
        # about invalid SQL when submitting multiple statements (joined by ;)
        #
        # Changed here to execute individually... still 2x faster than truncate so worth it.
        
        #sql = tables_to_truncate(connection).map do |table_name|
        #  "DELETE FROM #{connection.quote_table_name(table_name)}"
        #end.join(";")
        #
        #connection.execute sql

        tables_to_truncate(connection).each do |table_name|
          connection.execute "DELETE FROM #{connection.quote_table_name(table_name)}"
        end
      end
    end

  end
end


