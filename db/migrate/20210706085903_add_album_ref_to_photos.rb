class AddAlbumRefToPhotos < ActiveRecord::Migration[6.1]
  def change
    add_reference :photos, :album, null: false, foreign_key: true
  end
end
