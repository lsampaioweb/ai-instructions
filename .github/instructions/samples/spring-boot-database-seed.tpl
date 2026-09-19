INSERT INTO users (id, name, email) VALUES (1, 'User One', 'user-one@example.com')
ON CONFLICT (id) DO NOTHING;