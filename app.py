from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return "¡Hola Mundo desde Flask con CI/CD Automatizado! 🚀✅"

@app.route('/health')
def health():
    return {"status": "healthy", "service": "Flask App"}

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)