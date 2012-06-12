class AddForeignKeySourceId < ActiveRecord::Migration
  def up
    execute "ALTER TABLE alignments ADD CONSTRAINT fk_source_id FOREIGN KEY (source) REFERENCES sources(source_id)"
  end

  def down
    execute "ALTER TABLE alignments DROP CONSTRAINT fk_source_id"
  end
end
