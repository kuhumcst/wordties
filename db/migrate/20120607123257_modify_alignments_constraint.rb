class ModifyAlignmentsConstraint < ActiveRecord::Migration
  def up
	execute "ALTER TABLE ONLY alignments DROP CONSTRAINT alignments_source_and_key_and_syn_set_id_uniq"
	execute "ALTER TABLE ONLY alignments ADD CONSTRAINT alignments_source_and_key_and_syn_set_id_uniq UNIQUE (source, key, syn_set_id, relation_type_name, ext_syn_set_id)"
  end

  def down
	execute "ALTER TABLE ONLY alignments DROP CONSTRAINT alignments_source_and_key_and_syn_set_id_uniq"
	execute "ALTER TABLE ONLY alignments ADD CONSTRAINT alignments_source_and_key_and_syn_set_id_uniq UNIQUE (source, key, syn_set_id)"
  end
end
