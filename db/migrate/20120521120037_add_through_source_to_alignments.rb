class AddThroughSourceToAlignments < ActiveRecord::Migration
  def change
    add_column :alignments, :through_source, :string
    
  end
end
