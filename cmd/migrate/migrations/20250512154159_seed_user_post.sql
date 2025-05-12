-- +goose Up
-- +goose StatementBegin
-- Function to generate a random timestamp within a range
CREATE OR REPLACE FUNCTION random_timestamp(start_date TIMESTAMP, end_date TIMESTAMP) RETURNS TIMESTAMP AS $$ BEGIN RETURN start_date + (random() * (end_date - start_date));
END;
$$ LANGUAGE plpgsql;
-- Function to generate a random string
CREATE OR REPLACE FUNCTION random_string(length INTEGER) RETURNS TEXT AS $$
DECLARE chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
result TEXT := '';
i INTEGER;
BEGIN FOR i IN 1..length LOOP result := result || substr(
    chars,
    (random() * (length(chars) - 1) + 1)::INTEGER,
    1
);
END LOOP;
RETURN result;
END;
$$ LANGUAGE plpgsql;
-- Insert Users (50 characters from Marvel and DC)
INSERT INTO "User" (name, email, password, picture_url)
VALUES (
        'Spider-Man',
        'peter.parker@marvel.com',
        'password123',
        'https://via.placeholder.com/150/0000FF/808080?text=Spider-Man'
    ),
    (
        'Iron Man',
        'tony.stark@marvel.com',
        'password456',
        'https://via.placeholder.com/150/FF0000/FFFFFF?text=Iron+Man'
    ),
    (
        'Captain America',
        'steve.rogers@marvel.com',
        'password789',
        'https://via.placeholder.com/150/0000FF/FFFFFF?text=Captain+America'
    ),
    (
        'Thor',
        'thor.odinson@marvel.com',
        'password101',
        'https://via.placeholder.com/150/FFD700/000000?text=Thor'
    ),
    (
        'Hulk',
        'bruce.banner@marvel.com',
        'password202',
        'https://via.placeholder.com/150/00FF00/FFFFFF?text=Hulk'
    ),
    (
        'Black Widow',
        'natasha.romanoff@marvel.com',
        'password303',
        'https://via.placeholder.com/150/000000/FFFFFF?text=Black+Widow'
    ),
    (
        'Captain Marvel',
        'carol.danvers@marvel.com',
        'password404',
        'https://via.placeholder.com/150/6495ED/000000?text=Captain+Marvel'
    ),
    (
        'Doctor Strange',
        'stephen.strange@marvel.com',
        'password505',
        'https://via.placeholder.com/150/8B008B/FFFFFF?text=Doctor+Strange'
    ),
    (
        'Scarlet Witch',
        'wanda.maximoff@marvel.com',
        'password606',
        'https://via.placeholder.com/150/FF1493/000000?text=Scarlet+Witch'
    ),
    (
        'Ant-Man',
        'scott.lang@marvel.com',
        'password707',
        'https://via.placeholder.com/150/FFA500/000000?text=Ant-Man'
    ),
    (
        'Wasp',
        'hope.pym@marvel.com',
        'password808',
        'https://via.placeholder.com/150/F5F5DC/000000?text=Wasp'
    ),
    (
        'Hawkeye',
        'clint.barton@marvel.com',
        'password909',
        'https://via.placeholder.com/150/B22222/FFFFFF?text=Hawkeye'
    ),
    (
        'Falcon',
        'sam.wilson@marvel.com',
        'password111',
        'https://via.placeholder.com/150/87CEFA/000000?text=Falcon'
    ),
    (
        'Winter Soldier',
        'bucky.barnes@marvel.com',
        'password222',
        'https://via.placeholder.com/150/D3D3D3/000000?text=Winter+Soldier'
    ),
    (
        'Loki',
        'loki.odinson@marvel.com',
        'password333',
        'https://via.placeholder.com/150/483D8B/FFFFFF?text=Loki'
    ),
    (
        'Deadpool',
        'wade.wilson@marvel.com',
        'password444',
        'https://via.placeholder.com/150/DC143C/FFFFFF?text=Deadpool'
    ),
    (
        'Black Panther',
        'tChalla@marvel.com',
        'password555',
        'https://via.placeholder.com/150/000000/FFFFFF?text=Black+Panther'
    ),
    (
        'Vision',
        'vision@marvel.com',
        'password666',
        'https://via.placeholder.com/150/800080/FFFFFF?text=Vision'
    ),
    (
        'Gamora',
        'gamora@marvel.com',
        'password777',
        'https://via.placeholder.com/150/006400/FFFFFF?text=Gamora'
    ),
    (
        'Star-Lord',
        'peter.quill@marvel.com',
        'password888',
        'https://via.placeholder.com/150/4169E1/FFFFFF?text=Star-Lord'
    ),
    (
        'Rocket Raccoon',
        'rocket@marvel.com',
        'password999',
        'https://via.placeholder.com/150/A0522D/FFFFFF?text=Rocket+Raccoon'
    ),
    (
        'Groot',
        'groot@marvel.com',
        'iamgroot',
        'https://via.placeholder.com/150/228B22/FFFFFF?text=Groot'
    ),
    (
        'Drax',
        'drax@marvel.com',
        'password121',
        'https://via.placeholder.com/150/8B4513/FFFFFF?text=Drax'
    ),
    (
        'Mantis',
        'mantis@marvel.com',
        'password131',
        'https://via.placeholder.com/150/90EE90/000000?text=Mantis'
    ),
    (
        'Nebula',
        'nebula@marvel.com',
        'password141',
        'https://via.placeholder.com/150/D87093/000000?text=Nebula'
    ),
    (
        'Superman',
        'clark.kent@dc.com',
        'krypton123',
        'https://via.placeholder.com/150/B22222/FFFFFF?text=Superman'
    ),
    (
        'Batman',
        'bruce.wayne@dc.com',
        'gotham456',
        'https://via.placeholder.com/150/000000/FFFFFF?text=Batman'
    ),
    (
        'Wonder Woman',
        'diana.prince@dc.com',
        'themyscira789',
        'https://via.placeholder.com/150/DC143C/FFFFFF?text=Wonder+Woman'
    ),
    (
        'The Flash',
        'barry.allen@dc.com',
        'speedforce101',
        'https://via.placeholder.com/150/FFD700/000000?text=The+Flash'
    ),
    (
        'Green Lantern',
        'hal.jordan@dc.com',
        'emerald202',
        'https://via.placeholder.com/150/00FF00/FFFFFF?text=Green+Lantern'
    ),
    (
        'Aquaman',
        'arthur.curry@dc.com',
        'atlantis303',
        'https://via.placeholder.com/150/0000FF/FFFFFF?text=Aquaman'
    ),
    (
        'Cyborg',
        'victor.stone@dc.com',
        'techtitan404',
        'https://via.placeholder.com/150/4682B4/FFFFFF?text=Cyborg'
    ),
    (
        'Martian Manhunter',
        'jJonzz@dc.com',
        'mars505',
        'https://via.placeholder.com/150/800000/FFFFFF?text=Martian+Manhunter'
    ),
    (
        'Supergirl',
        'kara.zorEl@dc.com',
        'krypton606',
        'https://via.placeholder.com/150/B22222/FFFFFF?text=Supergirl'
    ),
    (
        'Green Arrow',
        'oliver.queen@dc.com',
        'starling707',
        'https://via.placeholder.com/150/228B22/FFFFFF?text=Green+Arrow'
    ),
    (
        'Batgirl',
        'barbara.gordon@dc.com',
        'oracle808',
        'https://via.placeholder.com/150/FFB6C1/000000?text=Batgirl'
    ),
    (
        'Nightwing',
        'dick.grayson@dc.com',
        'bludhaven909',
        'https://via.placeholder.com/150/4169E1/FFFFFF?text=Nightwing'
    ),
    (
        'Robin',
        'damian.wayne@dc.com',
        'robin111',
        'https://via.placeholder.com/150/DC143C/FFFFFF?text=Robin'
    ),
    (
        'Harley Quinn',
        'harleen.quinzel@dc.com',
        'puddin222',
        'https://via.placeholder.com/150/FF69B4/000000?text=Harley+Quinn'
    ),
    (
        'The Joker',
        'joker@dc.com',
        'chaos333',
        'https://via.placeholder.com/150/000000/FFFFFF?text=The+Joker'
    ),
    (
        'Lex Luthor',
        'lex.luthor@dc.com',
        'metropolis444',
        'https://via.placeholder.com/150/800080/FFFFFF?text=Lex+Luthor'
    ),
    (
        'Darkseid',
        'darkseid@dc.com',
        'apokolips555',
        'https://via.placeholder.com/150/2F4F4F/FFFFFF?text=Darkseid'
    ),
    (
        'Deathstroke',
        'slade.wilson@dc.com',
        'titan666',
        'https://via.placeholder.com/150/000000/FFFFFF?text=Deathstroke'
    ),
    (
        'Poison Ivy',
        'pamela.isley@dc.com',
        'green777',
        'https://via.placeholder.com/150/228B22/FFFFFF?text=Poison+Ivy'
    ),
    (
        'Catwoman',
        'selina.kyle@dc.com',
        'shadow888',
        'https://via.placeholder.com/150/000000/FFFFFF?text=Catwoman'
    ),
    (
        'The Riddler',
        'edward.nigma@dc.com',
        'enigma999',
        'https://via.placeholder.com/150/00008B/FFFFFF?text=The+Riddler'
    ),
    (
        'Scarecrow',
        'jonathan.crane@dc.com',
        'fear121',
        'https://via.placeholder.com/150/8B4513/FFFFFF?text=Scarecrow'
    ),
    (
        'Bane',
        'bane@dc.com',
        'venom131',
        'https://via.placeholder.com/150/800000/FFFFFF?text=Bane'
    ),
    (
        'Two-Face',
        'harvey.dent@dc.com',
        'coin141',
        'https://via.placeholder.com/150/808080/000000?text=Two-Face'
    );
-- Insert Posts (100 posts, related to the users)
DO $$
DECLARE user_id BIGINT;
i INTEGER;
post_date TIMESTAMP;
BEGIN FOR i IN 1..100 LOOP -- Randomly select a user
SELECT id INTO user_id
FROM "User"
ORDER BY random()
LIMIT 1;
post_date := random_timestamp(
    '2023-01-01 00:00:00'::TIMESTAMP, '2024-01-01 00:00:00'::TIMESTAMP
);
-- Insert post
INSERT INTO "Post" (user_id, title, content, created_at, updated_at)
VALUES (
        user_id,
        CASE
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Spider-Man'
            ) THEN 'My Greatest Responsibility'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Iron Man'
            ) THEN 'Building a Better World'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Captain America'
            ) THEN 'Fighting for Freedom'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Thor'
            ) THEN 'The Power of Thunder'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Hulk'
            ) THEN 'Hulk Smash!!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Black Widow'
            ) THEN 'Covert Operations'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Captain Marvel'
            ) THEN 'Higher, Further, Faster'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Doctor Strange'
            ) THEN 'Master of the Mystic Arts'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Scarlet Witch'
            ) THEN 'Reality Warping Powers'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Ant-Man'
            ) THEN 'Size Doesn''t Matter'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Wasp'
            ) THEN 'Stinging into Action'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Hawkeye'
            ) THEN 'Bullseye!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Falcon'
            ) THEN 'Soaring to New Heights'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Winter Soldier'
            ) THEN 'Redemption'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Loki'
            ) THEN 'Mischief Managed'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Deadpool'
            ) THEN 'Maximum Effort!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Black Panther'
            ) THEN 'Wakanda Forever'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Vision'
            ) THEN 'Synthezoid Insights'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Gamora'
            ) THEN 'The Deadliest Woman'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Star-Lord'
            ) THEN 'Guardians of the Galaxy'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Rocket Raccoon'
            ) THEN 'Blasting Off!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Groot'
            ) THEN 'I am Groot'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Drax'
            ) THEN 'Destroyer of Worlds'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Mantis'
            ) THEN 'Empathic Abilities'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Nebula'
            ) THEN 'Cybernetic Strength'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Superman'
            ) THEN 'Hope for Tomorrow'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Batman'
            ) THEN 'The Dark Knight'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Wonder Woman'
            ) THEN 'Warrior of Truth'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Flash'
            ) THEN 'Fastest Man Alive'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Green Lantern'
            ) THEN 'Willpower Incarnate'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Aquaman'
            ) THEN 'King of the Seven Seas'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Cyborg'
            ) THEN 'Man and Machine'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Martian Manhunter'
            ) THEN 'Last of Mars'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Supergirl'
            ) THEN 'Girl of Steel'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Green Arrow'
            ) THEN 'Emerald Archer'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Batgirl'
            ) THEN 'Guardian of Gotham'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Nightwing'
            ) THEN 'Aerial Acrobat'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Robin'
            ) THEN 'Boy Wonder'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Harley Quinn'
            ) THEN 'Chaos Agent'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Joker'
            ) THEN 'Agent of Chaos'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Lex Luthor'
            ) THEN 'Genius Billionaire'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Darkseid'
            ) THEN 'Ruler of Apokolips'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Deathstroke'
            ) THEN 'Deadly Assassin'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Poison Ivy'
            ) THEN 'Eco-Terrorist'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Catwoman'
            ) THEN 'Feline Fatale'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Riddler'
            ) THEN 'Prince of Puzzles'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Scarecrow'
            ) THEN 'Master of Fear'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Bane'
            ) THEN 'The Man Who Broke the Bat'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Two-Face'
            ) THEN 'Duality of Man'
            ELSE 'A Random Post'
        END,
        CASE
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Spider-Man'
            ) THEN 'With great power, there must also come great responsibility.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Iron Man'
            ) THEN 'I am Iron Man.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Captain America'
            ) THEN 'I can do this all day.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Thor'
            ) THEN 'Whosoever holds this hammer, if he be worthy, shall possess the power of Thor.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Hulk'
            ) THEN 'Hulk is strongest one there is!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Black Widow'
            ) THEN 'I have red in my ledger. I''d like to wipe it out.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Captain Marvel'
            ) THEN 'Higher, further, faster, baby.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Doctor Strange'
            ) THEN 'We are the masters of the mystic arts.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Scarlet Witch'
            ) THEN 'I can''t control it!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Ant-Man'
            ) THEN 'Is it too late to change my superhero name?'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Wasp'
            ) THEN 'Don''t call me honey.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Hawkeye'
            ) THEN 'I retired for my family.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Falcon'
            ) THEN 'On your left.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Winter Soldier'
            ) THEN 'I remember everything.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Loki'
            ) THEN 'I am burdened with glorious purpose.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Deadpool'
            ) THEN 'Chimichangas!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Black Panther'
            ) THEN 'Wakanda Forever!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Vision'
            ) THEN 'But a thing is not defined by its origins, but by its purpose.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Gamora'
            ) THEN 'Let me do the math. You, me, Quill, and the big guy – that’s five of us. We’re the Guardians of the Galaxy.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Star-Lord'
            ) THEN 'I am Star-Lord!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Rocket Raccoon'
            ) THEN 'Ain''t no thing like me, except me!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Groot'
            ) THEN 'I am Groot.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Drax'
            ) THEN 'Nothing goes over my head. My reflexes are too fast, I would catch it.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Mantis'
            ) THEN 'He is sad.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Nebula'
            ) THEN 'I wasn''t trying to escape you. I was trying to save you, you idiot!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Superman'
            ) THEN 'It''s not an S. On my world, it means hope.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Batman'
            ) THEN 'I''m Batman.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Wonder Woman'
            ) THEN 'I will fight for those who cannot fight for themselves.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Flash'
            ) THEN 'My name is Barry Allen, and I am the fastest man alive.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Green Lantern'
            ) THEN 'In brightest day, in blackest night, No evil shall escape my sight. Let those who worship evil''s might, Beware my power, Green Lantern''s light!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Aquaman'
            ) THEN 'I am Aquaman!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Cyborg'
            ) THEN 'Booyah!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Martian Manhunter'
            ) THEN 'I am the last son of Mars.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Supergirl'
            ) THEN 'For truth, justice, and a better tomorrow!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Green Arrow'
            ) THEN 'You have failed this city!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Batgirl'
            ) THEN 'I am vengeance. I am the night. I am Batgirl.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Nightwing'
            ) THEN 'My name is Nightwing. I''m here to help.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Robin'
            ) THEN 'Tt. Typical.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Harley Quinn'
            ) THEN 'Hi, Puddin! Ready to play?'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Joker'
            ) THEN 'Why so serious?'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Lex Luthor'
            ) THEN 'Power corrupts, and I am the most powerful man in the world.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Darkseid'
            ) THEN 'I am Darkseid. To bow before me is to live. To oppose me is to die.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Deathstroke'
            ) THEN 'I get paid to win.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Poison Ivy'
            ) THEN 'Kiss me. Go on, you know you want to.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Catwoman'
            ) THEN 'The name''s Catwoman. Play nice.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'The Riddler'
            ) THEN 'Riddle me this.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Scarecrow'
            ) THEN 'The only way to conquer fear is to become fear.'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Bane'
            ) THEN 'Let the games begin!'
            WHEN user_id IN (
                SELECT id
                FROM "User"
                WHERE name = 'Two-Face'
            ) THEN 'Flip for it.'
            ELSE 'This is a random post generated for the database.'
        END,
        post_date,
        post_date
    );
END LOOP;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
TRUNCATE TABLE Post,
User;
-- +goose StatementEnd