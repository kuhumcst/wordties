class ChangeColumnSourceToSourceId < ActiveRecord::Migration
  def up
    rename_column :alignments, :source, :source_id
  end

  def down
    rename_column :alignments, :source_id, :source
  end
end
