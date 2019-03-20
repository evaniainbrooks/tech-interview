# frozen_string_literal: true

# Mixtape API
# Interacts directly with a DAO
# Could easily be implemented as a client library for an external service
class MixtapeApi
  def initialize(mixtape_dao)
    @dao = mixtape_dao
  end

  def create_playlist_song(playlist_song)
    # Validation
    playlist_id = playlist_song.fetch('playlist_id')
    song_id = playlist_song.fetch('song_id')
    playlist = @dao.find('playlists', playlist_id)
    @dao.find('songs', song_id)

    # Update
    playlist['song_ids'] << song_id
    @dao.update('playlists', [playlist])
    true
  end

  def create_playlist(playlist)
    # Validation
    user_id = playlist.fetch('user_id')
    @dao.find('users', user_id)
    playlist.fetch('song_ids').each do |song_id|
      @dao.find('songs', song_id)
    end

    # Insert
    @dao.insert('playlists', [playlist])
    true
  end

  def delete_playlist(playlist_id)
    # Validation & Delete
    @dao.delete('playlists', [playlist_id])
    true
  end
end
