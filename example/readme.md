# Examples

## Getting Started

1. Copy the `mpd.conf.example` file to `mpd.conf`.
2. Open `mpd.conf` and update all the file urls to point to the `example/mpd` folder.
	- `music_directory`
	- `playlist_directory`
	- `db_file`
	- `log_file`
	- `pid_file`
	- `state_file`
	- `sticker_file`
3. Copy all the files from the `example/mpd-example` directory to the `example/mpd` directory.
	- Alternatively, you can create all these files/folders (they can be blank).
4. Put some music in the `music_directory`.
5. Run the examples (MPD may need to update it's database).

## The Examples

### arbitrary-commands.dart

This allows you to enter anything into the application's stdin and it will send it to MPD. Then MPD will send a response back, and it will be printed to the screen.

### adding-songs.dart

This is an example of how you can add songs, tell MPD to play, and skip songs.

### requesting-data.dart

This is an example of how you can request some data from MPD's database.