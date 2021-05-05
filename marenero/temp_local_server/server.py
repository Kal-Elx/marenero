from flask import Flask

app = Flask(__name__)
app.debug = True


@app.route('/')
def root():
    return "Hello, World!", 200


@app.route('/callback')
def callback():
    return app.send_static_file("spotify_callback.html")


if __name__ == '__main__':
    app.run(port=8888)
