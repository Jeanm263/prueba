from flask import Flask

app = Flask(__name__)

@app.route('/')
def hola():
    return "¡Hola mundo desde la casa de jean !"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
