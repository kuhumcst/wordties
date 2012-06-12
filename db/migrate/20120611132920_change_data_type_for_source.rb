class ChangeDataTypeForSource < ActiveRecord::Migration
  def up
    create_table :instances, {:id => true} do |t|
        t.string :uri
        t.datetime :last_uptime
    end
    
    create_table :sources, {:id => false} do |t|
        t.string :source_id
        t.references :instance
        t.string :lang
    end
    
    execute "ALTER TABLE sources ADD PRIMARY KEY (source_id);"
    
  end

  def down
    drop_table :instances
    drop_table :sources
  end
end
