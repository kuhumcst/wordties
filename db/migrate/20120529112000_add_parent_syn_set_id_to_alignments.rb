class AddParentSynSetIdToAlignments < ActiveRecord::Migration
  def up
    add_column :alignments, :parent_syn_set_id, :integer 
    execute <<-SQL
          ALTER TABLE alignments
            ADD CONSTRAINT alignments_parent_synset_id
            FOREIGN KEY (parent_syn_set_id)
            REFERENCES syn_sets(id)
          SQL
  end
  def down
    remove_column :alignments, :parent_syn_set_id
    execute <<-SQL
          ALTER TABLE  alignments
            DROP FOREIGN KEY alignments_parent_synset_id
          SQL
  end
end
