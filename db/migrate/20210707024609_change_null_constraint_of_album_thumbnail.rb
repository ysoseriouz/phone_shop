class ChangeNullConstraintOfAlbumThumbnail < ActiveRecord::Migration[6.1]
  def change
    change_column_null :albums, :thumbnail_id, true
  end
end
