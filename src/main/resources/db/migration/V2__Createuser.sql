CREATE TABLE users
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    name    VARCHAR(255) UNIQUE NOT NULL ,
    email    VARCHAR(255) UNIQUE NOT NULL ,
    role    VARCHAR(255) NOT NULL ,
    hashed_password    VARCHAR(255),
    created_at TIMESTAMP with time zone NOT NULL,

    CONSTRAINT pk_users PRIMARY KEY (id)
);

create TABLE follows
(
    id                    BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    created_at            TIMESTAMP with time zone                NOT NULL,
    fk_follower_user      BIGINT,
    fk_followee_user      BIGINT,
    notifications_enabled BOOLEAN,

    CONSTRAINT pk_follows PRIMARY KEY (id),
    CONSTRAINT fk_follower_user FOREIGN KEY (fk_follower_user) REFERENCES users (id),
    CONSTRAINT fk_followee_user FOREIGN KEY (fk_followee_user) REFERENCES users (id)
);

CREATE TABLE character_data
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    name VARCHAR(255),
    sex VARCHAR(255),
    age SMALLINT,
    birthday TIMESTAMP,
    first_seen VARCHAR(255),
    status VARCHAR(255),
    occupation VARCHAR(255),

    CONSTRAINT pk_character_data PRIMARY KEY (id)
);

CREATE TABLE location_data
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    name VARCHAR(255),

    CONSTRAINT pk_location_data PRIMARY KEY (id)
);

CREATE TABLE timeline_data
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    name    VARCHAR(255) NOT NULL ,
    first_seen VARCHAR(255),


    CONSTRAINT pk_timeline_data PRIMARY KEY (id)
);

CREATE TABLE articles
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    title    VARCHAR(255),
    body    TEXT NOT NULL,
    created_at TIMESTAMP with time zone NOT NULL,
    updated_at TIMESTAMP with time zone NOT NULL,
    author_id BIGINT NOT NULL,
    parent_article_id BIGINT,
    child_article_id BIGINT,
    timeline_id BIGINT,

    character_data_id BIGINT,
    timeline_data_id BIGINT,

    CONSTRAINT pk_articles PRIMARY KEY (id),
    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_parent_article_Id FOREIGN KEY (parent_article_id) REFERENCES articles (id),
    CONSTRAINT fk_child_article_Id FOREIGN KEY (child_article_id) REFERENCES articles (id),
    CONSTRAINT fk_timeline_id FOREIGN KEY (timeline_id) REFERENCES timeline_data (id),
    CONSTRAINT fk_character_data_id FOREIGN KEY (character_data_id) REFERENCES character_data (id),
    CONSTRAINT fk_timeline_data_id FOREIGN KEY (timeline_data_id) REFERENCES timeline_data (id)
);


CREATE TABLE comments
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    author_id BIGINT NOT NULL,
    body    TEXT NOT NULL,
    owning_article_id BIGINT NOT NULL,
    created_at TIMESTAMP with time zone NOT NULL,
    updated_at TIMESTAMP with time zone NOT NULL,

    CONSTRAINT pk_comments PRIMARY KEY (id),
    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users (id),
    CONSTRAINT fk_owning_article_id FOREIGN KEY (owning_article_id) REFERENCES articles (id)
);

CREATE TABLE comment_replies
(
    reply_to_id BIGINT NOT NULL,
    reply_id BIGINT NOT NULL,

    CONSTRAINT pk_comment_replies PRIMARY KEY (reply_id, reply_to_id),
    CONSTRAINT fk_reply_to_id FOREIGN KEY (reply_to_id) REFERENCES comments (id),
    CONSTRAINT fk_reply_id FOREIGN KEY (reply_id) REFERENCES comments (id),
    CONSTRAINT uc_comment_replies UNIQUE (reply_id, reply_to_id)
);

CREATE TABLE tags
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    name    VARCHAR(255) NOT NULL ,

    CONSTRAINT pk_tags PRIMARY KEY (id)
);

CREATE TABLE tags_to_articles
(
    tag_id BIGINT NOT NULL,
    article_id BIGINT NOT NULL,

    CONSTRAINT pk_tags_to_articles PRIMARY KEY (tag_id, article_id),
    CONSTRAINT fk_tag_id FOREIGN KEY (tag_id) REFERENCES tags (id),
    CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES articles (id),
    CONSTRAINT uc_tags_to_articles UNIQUE (tag_id, article_id)


);

CREATE TABLE files
(
    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
    created_at TIMESTAMP with time zone NOT NULL,
    updated_at TIMESTAMP with time zone NOT NULL,
    author_id BIGINT,
    owning_article_id BIGINT,
    name VARCHAR(255),

    CONSTRAINT pk_files PRIMARY KEY (id),
    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_owning_article_id FOREIGN KEY (owning_article_id) REFERENCES articles (id) ON DELETE CASCADE
);
--
--CREATE TABLE article_gallery_pics(
--    id   BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL ,
--    article_id BIGINT,
--    file_id BIGINT,
--
--    CONSTRAINT pk_article_gallery_pics PRIMARY KEY (id),
--    CONSTRAINT fk_article_id FOREIGN KEY (article_id) REFERENCES articles (id),
--    CONSTRAINT fk_file_id FOREIGN KEY (file_id) REFERENCES files (id)
--);


CREATE TABLE article_reactions
(
    emoji VARCHAR(255) NOT NULL,
    author_id BIGINT,

    CONSTRAINT fk_author_id FOREIGN KEY (author_id) REFERENCES users (id),
    CONSTRAINT fk_article_id FOREIGN KEY (author_id) REFERENCES articles (id)
);