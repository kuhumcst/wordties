class AddExtSynSetIdToAlignments < ActiveRecord::Migration
  def change
    add_column :alignments, :ext_syn_set_id, :integer

  end
end
