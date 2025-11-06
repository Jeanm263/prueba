import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hola_endpoint(client):
    """Test that the main endpoint returns the expected message"""
    rv = client.get('/')
    assert rv.status_code == 200
    # Using unicode string to avoid encoding issues
    assert '¡Hola mundo desde la casa de jean !' in rv.get_data(as_text=True)