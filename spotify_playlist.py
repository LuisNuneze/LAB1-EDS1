import requests
import json
import os

# Credenciales
client_id = "93177efd1fc949d7bec0bed3862aaeca"
client_secret = "6cd9ebbacefc437a9334f1d3d0504cae"

# Obtener token de acceso
def get_access_token(client_id, client_secret):
    url = "https://accounts.spotify.com/api/token"
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    data = {
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret
    }
    response = requests.post(url, headers=headers, data=data)
    return response.json().get("access_token")

# Obtener canciones
def get_playlist_tracks(playlist_id, token):
    url = f"https://api.spotify.com/v1/playlists/{playlist_id}/tracks"
    headers = {"Authorization": f"Bearer {token}"}
    all_tracks = []

    while url:
        res = requests.get(url, headers=headers)
        data = res.json()
        for item in data["items"]:
            track = item.get("track")
            if track:
                track_info = {
                    "track_name": track.get("name").replace(",", ""),
                    "artists": [artist["name"] for artist in track.get("artists", [])],
                    "album": track.get("album", {}).get("name"),
                    "duration_ms": track.get("duration_ms"),
                    "popularity": track.get("popularity"),
                    "track_url": track.get("external_urls", {}).get("spotify")
                }
                all_tracks.append(track_info)
        url = data.get("next")
    return all_tracks

if __name__ == "__main__":
    base_path = os.path.dirname(os.path.abspath(__file__))
    filePath = os.path.join(base_path, "playlist_id.txt")

    try:
        with open(filePath, "r") as reader:
            playlist_id = reader.readline().strip()
    except Exception as e:
        print("Error leyendo archivo:", e)
        playlist_id = None

    if not playlist_id:
        raise Exception("playlist_id no pudo ser leído del archivo.")

    token = get_access_token(client_id, client_secret)
    tracks = get_playlist_tracks(playlist_id, token)

    # Archivo 1: Canciones en formato .txt
    tracks_txt_path = os.path.join(base_path, "tracks.txt")
    with open(tracks_txt_path, "w", encoding="utf-8") as f:
        for t in tracks:
            artists = ";".join(t["artists"])
            f.write(f"{t['track_name']},{artists.replace(",", "")},{t['album']},{t['duration_ms']},{t['popularity']},{t['track_url']}\n")
    print(f"Archivo tracks.txt creado con éxito en {tracks_txt_path}")

    # Archivo 2: Artistas y sus canciones con popularidad
    
