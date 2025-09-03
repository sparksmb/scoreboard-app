class ChangeQuarterToStringWithPreDefault < ActiveRecord::Migration[7.2]
  def up
    # Add a temporary column to store string values
    add_column :scoreboards, :quarter_string, :string
    
    # Convert existing integer values to string equivalents
    execute <<-SQL
      UPDATE scoreboards 
      SET quarter_string = CASE 
        WHEN quarter = 1 THEN 'Q1'
        WHEN quarter = 2 THEN 'Q2'
        WHEN quarter = 3 THEN 'Q3'
        WHEN quarter = 4 THEN 'Q4'
        ELSE 'OT'
      END
    SQL
    
    # Remove the old integer column
    remove_column :scoreboards, :quarter
    
    # Rename the string column to quarter and set default
    rename_column :scoreboards, :quarter_string, :quarter
    change_column_default :scoreboards, :quarter, 'PRE'
  end
  
  def down
    # Add a temporary integer column
    add_column :scoreboards, :quarter_int, :integer
    
    # Convert string values back to integers for rollback
    execute <<-SQL
      UPDATE scoreboards 
      SET quarter_int = CASE 
        WHEN quarter = 'PRE' THEN 0
        WHEN quarter = 'Q1' THEN 1
        WHEN quarter = 'Q2' THEN 2
        WHEN quarter = 'HALF' THEN 2
        WHEN quarter = 'Q3' THEN 3
        WHEN quarter = 'Q4' THEN 4
        WHEN quarter = 'OT' THEN 5
        WHEN quarter = 'FINAL' THEN 5
        ELSE 1
      END
    SQL
    
    # Remove the string column
    remove_column :scoreboards, :quarter
    
    # Rename integer column back to quarter and set old default
    rename_column :scoreboards, :quarter_int, :quarter
    change_column_default :scoreboards, :quarter, 1
  end
end
