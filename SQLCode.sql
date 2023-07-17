BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "django_migrations" (
	"id"	integer NOT NULL,
	"app"	varchar(255) NOT NULL,
	"name"	varchar(255) NOT NULL,
	"applied"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_group_permissions" (
	"id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_groups" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"group_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("group_id") REFERENCES "auth_group"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_user_user_permissions" (
	"id"	integer NOT NULL,
	"user_id"	integer NOT NULL,
	"permission_id"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("permission_id") REFERENCES "auth_permission"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_admin_log" (
	"id"	integer NOT NULL,
	"object_id"	text,
	"object_repr"	varchar(200) NOT NULL,
	"action_flag"	smallint unsigned NOT NULL CHECK("action_flag" >= 0),
	"change_message"	text NOT NULL,
	"content_type_id"	integer,
	"user_id"	integer NOT NULL,
	"action_time"	datetime NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "django_content_type" (
	"id"	integer NOT NULL,
	"app_label"	varchar(100) NOT NULL,
	"model"	varchar(100) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_permission" (
	"id"	integer NOT NULL,
	"content_type_id"	integer NOT NULL,
	"codename"	varchar(100) NOT NULL,
	"name"	varchar(255) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("content_type_id") REFERENCES "django_content_type"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "auth_group" (
	"id"	integer NOT NULL,
	"name"	varchar(150) NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "auth_user" (
	"id"	integer NOT NULL,
	"password"	varchar(128) NOT NULL,
	"last_login"	datetime,
	"is_superuser"	bool NOT NULL,
	"username"	varchar(150) NOT NULL UNIQUE,
	"last_name"	varchar(150) NOT NULL,
	"email"	varchar(254) NOT NULL,
	"is_staff"	bool NOT NULL,
	"is_active"	bool NOT NULL,
	"date_joined"	datetime NOT NULL,
	"first_name"	varchar(150) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "django_session" (
	"session_key"	varchar(40) NOT NULL,
	"session_data"	text NOT NULL,
	"expire_date"	datetime NOT NULL,
	PRIMARY KEY("session_key")
);
CREATE TABLE IF NOT EXISTS "restaurant_api" (
	"id"	integer NOT NULL,
	"url"	varchar(500) NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "restaurant_item" (
	"id"	integer NOT NULL,
	"nome"	varchar(50) NOT NULL,
	"imagem"	varchar(100),
	"preco"	decimal NOT NULL,
	"tempo"	integer NOT NULL,
	"item_tipo"	varchar(50) NOT NULL,
	"restaurante_id"	bigint,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("restaurante_id") REFERENCES "restaurant_restaurante"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "restaurant_restaurante" (
	"id"	integer NOT NULL,
	"nome"	varchar(50) NOT NULL,
	"tipo"	varchar(50) NOT NULL,
	"descricao"	text,
	"imagem"	varchar(100),
	"destaque"	varchar(50) NOT NULL,
	"api_id"	bigint UNIQUE,
	"rating"	decimal,
	"tempo_medio"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("api_id") REFERENCES "restaurant_api"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "restaurant_pedido_restaurante" (
	"id"	integer NOT NULL,
	"pedido_id"	bigint NOT NULL,
	"restaurante_id"	bigint NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("pedido_id") REFERENCES "restaurant_pedido"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("restaurante_id") REFERENCES "restaurant_restaurante"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "user_profile" (
	"id"	integer NOT NULL,
	"role"	varchar(50) NOT NULL,
	"morada"	varchar(250),
	"contribuinte"	varchar(9),
	"user_id"	integer UNIQUE,
	"nome"	varchar(250) NOT NULL,
	"profile_imagem"	varchar(100),
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "auth_user"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "restaurant_itempedido" (
	"id"	integer NOT NULL,
	"item_id"	bigint,
	"pedido_id"	bigint,
	"quantidade"	integer NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("item_id") REFERENCES "restaurant_item"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("pedido_id") REFERENCES "restaurant_pedido"("id") DEFERRABLE INITIALLY DEFERRED
);
CREATE TABLE IF NOT EXISTS "restaurant_pedido" (
	"id"	integer NOT NULL,
	"data_inicio"	datetime NOT NULL,
	"data_conclusao"	datetime,
	"mesa"	integer NOT NULL,
	"finalizado"	bool NOT NULL,
	"numero_transacao"	varchar(100),
	"pedido_entregue"	bool NOT NULL,
	"pedido_pago"	bool NOT NULL,
	"cliente_id"	bigint,
	"entregador_id"	bigint,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("cliente_id") REFERENCES "user_profile"("id") DEFERRABLE INITIALLY DEFERRED,
	FOREIGN KEY("entregador_id") REFERENCES "user_profile"("id") DEFERRABLE INITIALLY DEFERRED
);
INSERT INTO "django_migrations" VALUES (1,'contenttypes','0001_initial','2023-06-03 12:14:55.845783');
INSERT INTO "django_migrations" VALUES (2,'auth','0001_initial','2023-06-03 12:14:55.851701');
INSERT INTO "django_migrations" VALUES (3,'admin','0001_initial','2023-06-03 12:14:55.855483');
INSERT INTO "django_migrations" VALUES (4,'admin','0002_logentry_remove_auto_add','2023-06-03 12:14:55.860841');
INSERT INTO "django_migrations" VALUES (5,'admin','0003_logentry_add_action_flag_choices','2023-06-03 12:14:55.863469');
INSERT INTO "django_migrations" VALUES (6,'contenttypes','0002_remove_content_type_name','2023-06-03 12:14:55.869695');
INSERT INTO "django_migrations" VALUES (7,'auth','0002_alter_permission_name_max_length','2023-06-03 12:14:55.873556');
INSERT INTO "django_migrations" VALUES (8,'auth','0003_alter_user_email_max_length','2023-06-03 12:14:55.877729');
INSERT INTO "django_migrations" VALUES (9,'auth','0004_alter_user_username_opts','2023-06-03 12:14:55.880685');
INSERT INTO "django_migrations" VALUES (10,'auth','0005_alter_user_last_login_null','2023-06-03 12:14:55.885041');
INSERT INTO "django_migrations" VALUES (11,'auth','0006_require_contenttypes_0002','2023-06-03 12:14:55.885894');
INSERT INTO "django_migrations" VALUES (12,'auth','0007_alter_validators_add_error_messages','2023-06-03 12:14:55.889698');
INSERT INTO "django_migrations" VALUES (13,'auth','0008_alter_user_username_max_length','2023-06-03 12:14:55.893846');
INSERT INTO "django_migrations" VALUES (14,'auth','0009_alter_user_last_name_max_length','2023-06-03 12:14:55.897873');
INSERT INTO "django_migrations" VALUES (15,'auth','0010_alter_group_name_max_length','2023-06-03 12:14:55.901785');
INSERT INTO "django_migrations" VALUES (16,'auth','0011_update_proxy_permissions','2023-06-03 12:14:55.904341');
INSERT INTO "django_migrations" VALUES (17,'auth','0012_alter_user_first_name_max_length','2023-06-03 12:14:55.908567');
INSERT INTO "django_migrations" VALUES (18,'sessions','0001_initial','2023-06-03 12:14:55.910571');
INSERT INTO "django_migrations" VALUES (19,'user','0001_initial','2023-06-09 21:47:03.036591');
INSERT INTO "django_migrations" VALUES (20,'restaurant','0001_initial','2023-06-09 21:47:03.048529');
INSERT INTO "django_migrations" VALUES (21,'restaurant','0002_alter_restaurante_imagem','2023-06-09 22:19:29.254916');
INSERT INTO "django_migrations" VALUES (22,'restaurant','0003_pedido_restaurante_restaurante_rating','2023-06-11 10:45:24.172678');
INSERT INTO "django_migrations" VALUES (23,'restaurant','0004_restaurante_tempo_medio','2023-06-11 10:46:47.100495');
INSERT INTO "django_migrations" VALUES (24,'restaurant','0005_rename_profile_pedido_cliente','2023-06-11 17:33:01.951642');
INSERT INTO "django_migrations" VALUES (25,'user','0002_profile_nome','2023-06-11 17:36:53.087334');
INSERT INTO "django_migrations" VALUES (26,'restaurant','0006_remove_pedido_restaurante_pedido_restaurante','2023-06-11 17:43:26.227221');
INSERT INTO "django_migrations" VALUES (27,'restaurant','0007_alter_pedido_restaurante','2023-06-15 17:53:22.493298');
INSERT INTO "django_migrations" VALUES (28,'user','0003_profile_profile_imagem','2023-06-15 17:53:22.499772');
INSERT INTO "django_migrations" VALUES (29,'restaurant','0008_pedido_pedido_entregue_pedido_pedido_pago','2023-06-19 18:37:06.808082');
INSERT INTO "django_migrations" VALUES (30,'restaurant','0009_alter_itempedido_quantidade_alter_pedido_cliente_and_more','2023-06-24 19:18:07.800894');
INSERT INTO "django_migrations" VALUES (31,'restaurant','0010_remove_pedido_cliente','2023-06-24 19:55:08.456093');
INSERT INTO "django_migrations" VALUES (32,'restaurant','0011_pedido_cliente_pedido_entregador','2023-06-24 19:57:34.807691');
INSERT INTO "auth_group_permissions" VALUES (13,4,13);
INSERT INTO "auth_group_permissions" VALUES (14,4,14);
INSERT INTO "auth_group_permissions" VALUES (16,4,16);
INSERT INTO "auth_group_permissions" VALUES (25,4,25);
INSERT INTO "auth_group_permissions" VALUES (26,4,26);
INSERT INTO "auth_group_permissions" VALUES (27,4,27);
INSERT INTO "auth_group_permissions" VALUES (28,4,28);
INSERT INTO "auth_group_permissions" VALUES (33,4,33);
INSERT INTO "auth_group_permissions" VALUES (34,4,34);
INSERT INTO "auth_group_permissions" VALUES (35,4,35);
INSERT INTO "auth_group_permissions" VALUES (36,4,36);
INSERT INTO "auth_group_permissions" VALUES (41,4,41);
INSERT INTO "auth_group_permissions" VALUES (42,4,42);
INSERT INTO "auth_group_permissions" VALUES (43,4,43);
INSERT INTO "auth_group_permissions" VALUES (44,4,44);
INSERT INTO "auth_group_permissions" VALUES (45,4,45);
INSERT INTO "auth_group_permissions" VALUES (46,4,46);
INSERT INTO "auth_group_permissions" VALUES (47,4,47);
INSERT INTO "auth_group_permissions" VALUES (48,4,48);
INSERT INTO "auth_group_permissions" VALUES (49,3,41);
INSERT INTO "auth_group_permissions" VALUES (50,3,42);
INSERT INTO "auth_group_permissions" VALUES (51,3,43);
INSERT INTO "auth_group_permissions" VALUES (52,3,44);
INSERT INTO "auth_user_groups" VALUES (3,4,4);
INSERT INTO "auth_user_groups" VALUES (4,5,3);
INSERT INTO "auth_user_groups" VALUES (5,6,1);
INSERT INTO "auth_user_groups" VALUES (6,7,2);
INSERT INTO "django_admin_log" VALUES (1,'1','user',1,'[{"added": {}}]',3,1,'2023-06-03 12:31:56.871814');
INSERT INTO "django_admin_log" VALUES (2,'2','delivery',1,'[{"added": {}}]',3,1,'2023-06-03 12:32:16.943264');
INSERT INTO "django_admin_log" VALUES (3,'3','restAdmin',1,'[{"added": {}}]',3,1,'2023-06-03 12:32:25.517327');
INSERT INTO "django_admin_log" VALUES (4,'4','admin',1,'[{"added": {}}]',3,1,'2023-06-03 12:32:44.205897');
INSERT INTO "django_admin_log" VALUES (5,'3','rest_admin',2,'[{"changed": {"fields": ["Name"]}}]',3,1,'2023-06-03 12:32:58.756417');
INSERT INTO "django_admin_log" VALUES (6,'1','http://restaurant:8080/api/v1/',1,'[{"added": {}}]',7,1,'2023-06-09 22:00:01.612743');
INSERT INTO "django_admin_log" VALUES (7,'1','Restaurante Simulado',1,'[{"added": {}}]',9,1,'2023-06-09 22:03:23.216689');
INSERT INTO "django_admin_log" VALUES (8,'1','http://restaurant:8080/api/v1/',2,'[]',7,1,'2023-06-09 22:15:14.282000');
INSERT INTO "django_admin_log" VALUES (9,'1','Restaurante Simulado',2,'[{"changed": {"fields": ["Imagem"]}}]',9,1,'2023-06-09 22:19:55.359352');
INSERT INTO "django_admin_log" VALUES (10,'2','MacDonaldo',1,'[{"added": {}}]',9,1,'2023-06-09 22:27:14.791202');
INSERT INTO "django_admin_log" VALUES (11,'1','Simulado',2,'[{"changed": {"fields": ["Nome"]}}]',9,1,'2023-06-09 22:29:57.491082');
INSERT INTO "django_admin_log" VALUES (12,'3','Divino',1,'[{"added": {}}]',9,1,'2023-06-10 08:20:44.433880');
INSERT INTO "django_admin_log" VALUES (13,'3','Divino',2,'[{"changed": {"fields": ["Tipo"]}}]',9,1,'2023-06-10 08:22:04.339583');
INSERT INTO "django_admin_log" VALUES (14,'4','Petiscos',1,'[{"added": {}}]',9,1,'2023-06-11 10:28:39.226911');
INSERT INTO "django_admin_log" VALUES (15,'5','GoldenPizza',1,'[{"added": {}}]',9,1,'2023-06-11 10:32:23.062984');
INSERT INTO "django_admin_log" VALUES (16,'6','FinePasta',1,'[{"added": {}}]',9,1,'2023-06-11 10:40:10.482310');
INSERT INTO "django_admin_log" VALUES (17,'6','FinePasta',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:47:49.643728');
INSERT INTO "django_admin_log" VALUES (18,'5','GoldenPizza',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:47:57.536746');
INSERT INTO "django_admin_log" VALUES (19,'4','Petiscos',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:48:05.647173');
INSERT INTO "django_admin_log" VALUES (20,'3','Divino',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:48:14.762778');
INSERT INTO "django_admin_log" VALUES (21,'2','MacDonaldo',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:48:21.059435');
INSERT INTO "django_admin_log" VALUES (22,'1','Simulado',2,'[{"changed": {"fields": ["Rating"]}}]',9,1,'2023-06-11 10:48:27.026757');
INSERT INTO "django_admin_log" VALUES (23,'6','FinePasta',2,'[{"changed": {"fields": ["Tempo medio"]}}]',9,1,'2023-06-11 10:48:42.498925');
INSERT INTO "django_admin_log" VALUES (24,'5','GoldenPizza',2,'[{"changed": {"fields": ["Tempo medio"]}}]',9,1,'2023-06-11 10:48:46.778762');
INSERT INTO "django_admin_log" VALUES (25,'4','Petiscos',2,'[{"changed": {"fields": ["Tempo medio"]}}]',9,1,'2023-06-11 10:48:52.189255');
INSERT INTO "django_admin_log" VALUES (26,'3','Divino',2,'[]',9,1,'2023-06-11 10:48:57.819328');
INSERT INTO "django_admin_log" VALUES (27,'2','MacDonaldo',2,'[{"changed": {"fields": ["Tempo medio"]}}]',9,1,'2023-06-11 10:49:02.199061');
INSERT INTO "django_admin_log" VALUES (28,'1','Simulado',2,'[{"changed": {"fields": ["Tempo medio"]}}]',9,1,'2023-06-11 10:49:06.241504');
INSERT INTO "django_admin_log" VALUES (29,'1','http://restaurant:8080/api/v1/items/',2,'[{"changed": {"fields": ["Url"]}}]',7,1,'2023-06-11 14:36:43.293710');
INSERT INTO "django_admin_log" VALUES (30,'1','http://restaurant:8080/api/v1/',2,'[{"changed": {"fields": ["Url"]}}]',7,1,'2023-06-11 14:36:54.326688');
INSERT INTO "django_admin_log" VALUES (31,'4','admin',2,'[{"changed": {"fields": ["Permissions"]}}]',3,1,'2023-06-11 14:49:32.055761');
INSERT INTO "django_admin_log" VALUES (32,'3','rest_admin',2,'[{"changed": {"fields": ["Permissions"]}}]',3,1,'2023-06-11 14:50:19.534076');
INSERT INTO "django_admin_log" VALUES (33,'2','testuser1',2,'[{"changed": {"fields": ["Groups"]}}]',4,1,'2023-06-11 14:50:48.083088');
INSERT INTO "django_admin_log" VALUES (34,'3','testuser3',2,'[{"changed": {"fields": ["Groups", "User permissions"]}}]',4,1,'2023-06-11 14:52:28.538579');
INSERT INTO "django_admin_log" VALUES (35,'3','testuser3',3,'',4,1,'2023-06-11 14:52:47.926232');
INSERT INTO "django_admin_log" VALUES (36,'2','RestAdmin',2,'[{"changed": {"fields": ["Username"]}}]',4,1,'2023-06-11 14:53:30.425340');
INSERT INTO "django_admin_log" VALUES (37,'2','restadmin',2,'[{"changed": {"fields": ["Username"]}}]',4,1,'2023-06-11 14:53:39.508054');
INSERT INTO "django_admin_log" VALUES (38,'2','user-restadmin',2,'[{"changed": {"fields": ["Username"]}}]',4,1,'2023-06-11 15:05:18.887067');
INSERT INTO "django_admin_log" VALUES (39,'2','user-restadmin',2,'[{"changed": {"fields": ["Staff status"]}}]',4,1,'2023-06-11 15:06:31.868510');
INSERT INTO "django_admin_log" VALUES (40,'4','useradmin',1,'[{"added": {}}]',4,1,'2023-06-11 15:07:55.297294');
INSERT INTO "django_admin_log" VALUES (41,'4','useradmin',2,'[{"changed": {"fields": ["Staff status", "Groups"]}}]',4,1,'2023-06-11 15:08:06.301666');
INSERT INTO "django_admin_log" VALUES (42,'2','user-restadmin',3,'',4,1,'2023-06-11 15:08:23.307992');
INSERT INTO "django_admin_log" VALUES (43,'5','user-restadmin',1,'[{"added": {}}]',4,1,'2023-06-11 15:08:36.729866');
INSERT INTO "django_admin_log" VALUES (44,'5','user-restadmin',2,'[{"changed": {"fields": ["Staff status", "Groups"]}}]',4,1,'2023-06-11 15:08:47.370031');
INSERT INTO "django_admin_log" VALUES (45,'6','normaluser',1,'[{"added": {}}]',4,1,'2023-06-11 15:09:06.546728');
INSERT INTO "django_admin_log" VALUES (46,'6','normaluser',2,'[{"changed": {"fields": ["Groups"]}}]',4,1,'2023-06-11 15:09:13.601705');
INSERT INTO "django_admin_log" VALUES (47,'7','deliveryuser',1,'[{"added": {}}]',4,1,'2023-06-11 15:09:52.732703');
INSERT INTO "django_admin_log" VALUES (48,'7','deliveryuser',2,'[]',4,1,'2023-06-11 15:09:59.964349');
INSERT INTO "django_admin_log" VALUES (49,'7','deliveryuser',2,'[{"changed": {"fields": ["Groups"]}}]',4,1,'2023-06-11 15:10:07.825492');
INSERT INTO "django_admin_log" VALUES (50,'4','admin',2,'[{"changed": {"fields": ["Permissions"]}}]',3,1,'2023-06-11 15:21:39.373190');
INSERT INTO "django_admin_log" VALUES (51,'1','admin',1,'[{"added": {}}]',12,1,'2023-06-11 17:32:26.358306');
INSERT INTO "django_admin_log" VALUES (52,'1','Ivo Nunes',2,'[{"changed": {"fields": ["Nome"]}}]',12,1,'2023-06-11 17:37:22.693171');
INSERT INTO "django_admin_log" VALUES (53,'1','1',1,'[{"added": {}}]',10,1,'2023-06-11 17:40:50.798459');
INSERT INTO "django_admin_log" VALUES (54,'1','1',2,'[{"changed": {"fields": ["Restaurante"]}}]',10,1,'2023-06-11 17:41:02.766316');
INSERT INTO "django_admin_log" VALUES (55,'1','1',2,'[{"changed": {"fields": ["Restaurante"]}}]',10,1,'2023-06-11 17:44:03.158094');
INSERT INTO "django_admin_log" VALUES (56,'1','Cola',1,'[{"added": {}}]',11,1,'2023-06-11 17:53:43.222178');
INSERT INTO "django_admin_log" VALUES (57,'2','Agua',1,'[{"added": {}}]',11,1,'2023-06-11 17:54:16.051138');
INSERT INTO "django_admin_log" VALUES (58,'3','Fanta',1,'[{"added": {}}]',11,1,'2023-06-11 17:54:35.208883');
INSERT INTO "django_admin_log" VALUES (59,'4','Pizza Margarita',1,'[{"added": {}}]',11,1,'2023-06-11 17:55:08.401977');
INSERT INTO "django_admin_log" VALUES (60,'5','Pizza Cogumelos',1,'[{"added": {}}]',11,1,'2023-06-11 17:55:44.058164');
INSERT INTO "django_admin_log" VALUES (61,'6','Pizza Peperoni',1,'[{"added": {}}]',11,1,'2023-06-11 17:56:19.750906');
INSERT INTO "django_admin_log" VALUES (62,'1','1',1,'[{"added": {}}]',8,1,'2023-06-11 20:17:03.186115');
INSERT INTO "django_admin_log" VALUES (63,'2','2',1,'[{"added": {}}]',8,1,'2023-06-11 20:17:08.712634');
INSERT INTO "django_admin_log" VALUES (64,'3','3',1,'[{"added": {}}]',8,1,'2023-06-11 20:17:13.959072');
INSERT INTO "django_admin_log" VALUES (65,'4','4',1,'[{"added": {}}]',8,1,'2023-06-11 20:17:19.252817');
INSERT INTO "django_admin_log" VALUES (66,'7','Pica-pau',1,'[{"added": {}}]',11,1,'2023-06-11 21:06:31.110716');
INSERT INTO "django_admin_log" VALUES (67,'1','1',2,'[{"changed": {"fields": ["Restaurante"]}}]',10,1,'2023-06-11 21:06:40.187897');
INSERT INTO "django_admin_log" VALUES (68,'2','2',2,'[{"changed": {"fields": ["Quantidade"]}}]',8,1,'2023-06-11 21:06:59.234291');
INSERT INTO "django_admin_log" VALUES (69,'1','1',2,'[]',8,1,'2023-06-11 21:07:01.433876');
INSERT INTO "django_admin_log" VALUES (70,'1','1',2,'[{"changed": {"fields": ["Item"]}}]',8,1,'2023-06-11 21:07:13.190852');
INSERT INTO "django_admin_log" VALUES (71,'1','Ivo Nunes',2,'[]',12,1,'2023-06-15 18:27:07.008469');
INSERT INTO "django_admin_log" VALUES (72,'2','2',3,'',10,1,'2023-06-22 13:16:58.529023');
INSERT INTO "django_admin_log" VALUES (73,'1','1',2,'[{"changed": {"fields": ["Pedido pago", "Numero transacao"]}}]',10,1,'2023-06-22 13:17:49.435016');
INSERT INTO "django_admin_log" VALUES (74,'2','Alberto',1,'[{"added": {}}]',12,1,'2023-06-24 19:13:05.204831');
INSERT INTO "django_admin_log" VALUES (75,'1','1',3,'',10,1,'2023-06-24 19:17:51.475894');
INSERT INTO "django_admin_log" VALUES (76,'1','1',3,'',10,1,'2023-06-24 19:55:33.690865');
INSERT INTO "django_admin_log" VALUES (77,'3','3',3,'',10,1,'2023-06-24 22:15:29.439715');
INSERT INTO "django_admin_log" VALUES (78,'2','2',3,'',10,1,'2023-06-24 22:15:29.444429');
INSERT INTO "django_admin_log" VALUES (79,'4','4',3,'',10,1,'2023-06-24 22:16:06.240592');
INSERT INTO "django_admin_log" VALUES (80,'5','5',3,'',10,1,'2023-06-24 22:18:02.080996');
INSERT INTO "django_admin_log" VALUES (81,'6','6',3,'',10,1,'2023-06-24 22:18:45.074882');
INSERT INTO "django_admin_log" VALUES (82,'7','7',3,'',10,1,'2023-06-24 22:20:45.060698');
INSERT INTO "django_admin_log" VALUES (83,'9','9',3,'',10,1,'2023-06-24 22:26:04.172856');
INSERT INTO "django_admin_log" VALUES (84,'8','8',2,'[{"changed": {"fields": ["Pedido pago"]}}]',10,1,'2023-06-24 22:26:08.299811');
INSERT INTO "django_admin_log" VALUES (85,'11','11',3,'',10,1,'2023-06-25 14:05:40.033018');
INSERT INTO "django_admin_log" VALUES (86,'10','10',3,'',10,1,'2023-06-25 14:05:40.036514');
INSERT INTO "django_admin_log" VALUES (87,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-25 14:48:59.686794');
INSERT INTO "django_admin_log" VALUES (88,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-25 15:09:12.586202');
INSERT INTO "django_admin_log" VALUES (89,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-25 15:10:03.814114');
INSERT INTO "django_admin_log" VALUES (90,'8','8',2,'[{"changed": {"fields": ["Pedido entregue"]}}]',10,1,'2023-06-25 15:12:40.422574');
INSERT INTO "django_admin_log" VALUES (91,'8','8',2,'[{"changed": {"fields": ["Pedido entregue"]}}]',10,1,'2023-06-26 19:34:26.401535');
INSERT INTO "django_admin_log" VALUES (92,'12','12',3,'',10,1,'2023-06-26 19:34:34.522275');
INSERT INTO "django_admin_log" VALUES (93,'2','Alberto',2,'[{"changed": {"fields": ["Profile imagem"]}}]',12,1,'2023-06-26 19:50:30.810954');
INSERT INTO "django_admin_log" VALUES (94,'6','normaluser',2,'[{"changed": {"fields": ["First name", "Last name"]}}]',4,1,'2023-06-26 19:50:51.747397');
INSERT INTO "django_admin_log" VALUES (95,'3','Pedro Penim',1,'[{"added": {}}]',12,1,'2023-06-26 19:52:06.014775');
INSERT INTO "django_admin_log" VALUES (96,'3','Pedro Penim',2,'[{"changed": {"fields": ["Contribuinte"]}}]',12,1,'2023-06-26 19:52:12.056853');
INSERT INTO "django_admin_log" VALUES (97,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-27 19:41:42.377311');
INSERT INTO "django_admin_log" VALUES (98,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-27 19:53:41.716289');
INSERT INTO "django_admin_log" VALUES (99,'8','8',2,'[{"changed": {"fields": ["Entregador"]}}]',10,1,'2023-06-27 19:54:33.820087');
INSERT INTO "django_admin_log" VALUES (100,'15','15',2,'[{"changed": {"fields": ["Mesa"]}}]',10,1,'2023-06-27 21:26:48.895484');
INSERT INTO "django_content_type" VALUES (1,'admin','logentry');
INSERT INTO "django_content_type" VALUES (2,'auth','permission');
INSERT INTO "django_content_type" VALUES (3,'auth','group');
INSERT INTO "django_content_type" VALUES (4,'auth','user');
INSERT INTO "django_content_type" VALUES (5,'contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES (6,'sessions','session');
INSERT INTO "django_content_type" VALUES (7,'restaurant','api');
INSERT INTO "django_content_type" VALUES (8,'restaurant','itempedido');
INSERT INTO "django_content_type" VALUES (9,'restaurant','restaurante');
INSERT INTO "django_content_type" VALUES (10,'restaurant','pedido');
INSERT INTO "django_content_type" VALUES (11,'restaurant','item');
INSERT INTO "django_content_type" VALUES (12,'user','profile');
INSERT INTO "auth_permission" VALUES (1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" VALUES (2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" VALUES (3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" VALUES (4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" VALUES (5,2,'add_permission','Can add permission');
INSERT INTO "auth_permission" VALUES (6,2,'change_permission','Can change permission');
INSERT INTO "auth_permission" VALUES (7,2,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" VALUES (8,2,'view_permission','Can view permission');
INSERT INTO "auth_permission" VALUES (9,3,'add_group','Can add group');
INSERT INTO "auth_permission" VALUES (10,3,'change_group','Can change group');
INSERT INTO "auth_permission" VALUES (11,3,'delete_group','Can delete group');
INSERT INTO "auth_permission" VALUES (12,3,'view_group','Can view group');
INSERT INTO "auth_permission" VALUES (13,4,'add_user','Can add user');
INSERT INTO "auth_permission" VALUES (14,4,'change_user','Can change user');
INSERT INTO "auth_permission" VALUES (15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" VALUES (16,4,'view_user','Can view user');
INSERT INTO "auth_permission" VALUES (17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" VALUES (18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" VALUES (19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" VALUES (20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" VALUES (21,6,'add_session','Can add session');
INSERT INTO "auth_permission" VALUES (22,6,'change_session','Can change session');
INSERT INTO "auth_permission" VALUES (23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" VALUES (24,6,'view_session','Can view session');
INSERT INTO "auth_permission" VALUES (25,7,'add_api','Can add api');
INSERT INTO "auth_permission" VALUES (26,7,'change_api','Can change api');
INSERT INTO "auth_permission" VALUES (27,7,'delete_api','Can delete api');
INSERT INTO "auth_permission" VALUES (28,7,'view_api','Can view api');
INSERT INTO "auth_permission" VALUES (29,8,'add_itempedido','Can add item pedido');
INSERT INTO "auth_permission" VALUES (30,8,'change_itempedido','Can change item pedido');
INSERT INTO "auth_permission" VALUES (31,8,'delete_itempedido','Can delete item pedido');
INSERT INTO "auth_permission" VALUES (32,8,'view_itempedido','Can view item pedido');
INSERT INTO "auth_permission" VALUES (33,9,'add_restaurante','Can add restaurante');
INSERT INTO "auth_permission" VALUES (34,9,'change_restaurante','Can change restaurante');
INSERT INTO "auth_permission" VALUES (35,9,'delete_restaurante','Can delete restaurante');
INSERT INTO "auth_permission" VALUES (36,9,'view_restaurante','Can view restaurante');
INSERT INTO "auth_permission" VALUES (37,10,'add_pedido','Can add pedido');
INSERT INTO "auth_permission" VALUES (38,10,'change_pedido','Can change pedido');
INSERT INTO "auth_permission" VALUES (39,10,'delete_pedido','Can delete pedido');
INSERT INTO "auth_permission" VALUES (40,10,'view_pedido','Can view pedido');
INSERT INTO "auth_permission" VALUES (41,11,'add_item','Can add item');
INSERT INTO "auth_permission" VALUES (42,11,'change_item','Can change item');
INSERT INTO "auth_permission" VALUES (43,11,'delete_item','Can delete item');
INSERT INTO "auth_permission" VALUES (44,11,'view_item','Can view item');
INSERT INTO "auth_permission" VALUES (45,12,'add_profile','Can add profile');
INSERT INTO "auth_permission" VALUES (46,12,'change_profile','Can change profile');
INSERT INTO "auth_permission" VALUES (47,12,'delete_profile','Can delete profile');
INSERT INTO "auth_permission" VALUES (48,12,'view_profile','Can view profile');
INSERT INTO "auth_group" VALUES (1,'user');
INSERT INTO "auth_group" VALUES (2,'delivery');
INSERT INTO "auth_group" VALUES (3,'rest_admin');
INSERT INTO "auth_group" VALUES (4,'admin');
INSERT INTO "auth_user" VALUES (1,'pbkdf2_sha256$600000$KUE9Q97o3lQTAA6GH5f4mX$fC9A855OJmUXXIaV64hINxWoI217yR3w/pv9roWZg4s=','2023-07-05 22:18:26.313997',1,'ivonunes','','20202567@uatla.pt',1,1,'2023-06-03 12:25:42.953820','');
INSERT INTO "auth_user" VALUES (4,'pbkdf2_sha256$600000$l4rxDauWT1QIs3A9jboc53$r6zgU8+CxI8DLMAN1SsPz4aCTGrCNHbvelMxATGRrxs=','2023-06-11 15:21:51.956569',0,'useradmin','','',1,1,'2023-06-11 15:07:55','');
INSERT INTO "auth_user" VALUES (5,'pbkdf2_sha256$600000$afqFpMbhVmkxeEbIbHAl80$fXG7la/qeNrIAhkvCcIIER/smrKiB0omef/PqpryACw=','2023-06-24 17:01:59.455576',0,'user-restadmin','','',1,1,'2023-06-11 15:08:36','');
INSERT INTO "auth_user" VALUES (6,'pbkdf2_sha256$600000$V9Y9o9r1V6wBpdgtXFNzW3$esrZtJ3pDASh3dZ6AYKy3D/CVx8IIOcIrDyvogoH3Q4=','2023-06-27 20:55:55.829117',0,'normaluser','Pequim','',0,1,'2023-06-11 15:09:06','Pedro');
INSERT INTO "auth_user" VALUES (7,'pbkdf2_sha256$600000$1lBtKjSGDn5cbM377dt2gM$/C8wz0ZolJVBzpflyrigmHi6D85V90JXEDR5P61CbDg=','2023-06-27 18:50:36.254400',0,'deliveryuser','','',0,1,'2023-06-11 15:09:52','');
INSERT INTO "auth_user" VALUES (8,'pbkdf2_sha256$600000$rwXOZclkiqnzsQ7EIjniqk$13AUpwg3NOY8q8KM2lSjKC67s0EeT4zpeHTJQdmENSc=','2023-07-05 20:48:12.141410',0,'ZAP','','zaproxy@example.com',0,1,'2023-07-05 20:42:16.631735','');
INSERT INTO "auth_user" VALUES (9,'pbkdf2_sha256$600000$mdJFlNoHiXSLk45YoEimg2$sgOSB2vylvzOZZkVn0TFCzVX+sEp/UldKq5r72rDzS8=',NULL,0,'c:/Windows/system.ini','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.048222','');
INSERT INTO "auth_user" VALUES (10,'pbkdf2_sha256$600000$LwFa0EYutNRExUOv2FEx5M$kWx5g7m7OjMJO704aZy5Df1kVVPC0MFGgOBMDXJEUmM=',NULL,0,'../../../../../../../../../../../../../../../../Windows/system.ini','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.239097','');
INSERT INTO "auth_user" VALUES (11,'pbkdf2_sha256$600000$R7WC0qXpNKpKqssTz99CGi$tc52X7rtpHQP6gLZgJgpfc1kHD5kh8+rFW1JzWWTgPo=',NULL,0,'c:\Windows\system.ini','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.424044','');
INSERT INTO "auth_user" VALUES (12,'pbkdf2_sha256$600000$EBTXpTCleemTR6RwVnjcpe$BSrO7PK5yUDsL9mtw1sKqEFHK76GdsC+GWew0/yOcck=',NULL,0,'..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\Windows\system.ini','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.607589','');
INSERT INTO "auth_user" VALUES (13,'pbkdf2_sha256$600000$hf1euE7JJkqvOabtiGToQK$TgqGemRth6zc7Hp3EBNDrNQHJuyo5A18e+BCkTvmB0o=',NULL,0,'/etc/passwd','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.788849','');
INSERT INTO "auth_user" VALUES (14,'pbkdf2_sha256$600000$O3BRLq8zBIMtpkxp74NiEd$aaGAmxp3RW2F/gQ1hq+FkElTKI/abP9VS+FiHdQQC3s=',NULL,0,'../../../../../../../../../../../../../../../../etc/passwd','','zaproxy@example.com',0,1,'2023-07-05 21:09:55.974493','');
INSERT INTO "auth_user" VALUES (15,'pbkdf2_sha256$600000$p3e7F9DGDBOKRHmCYBhwxo$p/GyjUVkxqLCY8qtKvXtwbsS6Ehh2IZ+kNYTgE5PQgI=',NULL,0,'c:/','','zaproxy@example.com',0,1,'2023-07-05 21:09:56.160206','');
INSERT INTO "auth_user" VALUES (16,'pbkdf2_sha256$600000$qrkCBXnZpDxWtZfCdlFmJr$tYgaTj+iTUfePtwcPXr1zvDm/uU/3xObjz0o3g054qo=',NULL,0,'/','','zaproxy@example.com',0,1,'2023-07-05 21:09:56.348991','');
INSERT INTO "auth_user" VALUES (17,'pbkdf2_sha256$600000$qnPdenBtZZOSsXppVNkv2m$DwOCOCy/EpiWsOgvVu1ueQnN0Ay/crpEfeJKO6IL0mI=',NULL,0,'c:\','','zaproxy@example.com',0,1,'2023-07-05 21:09:56.535378','');
INSERT INTO "auth_user" VALUES (18,'pbkdf2_sha256$600000$yyWpmsYummsEPC41eObMyD$F5yX2s2MqsItYeHnE7nN0ZsNkHnurzHCX8+OUajxDjs=',NULL,0,'../../../../../../../../../../../../../../../../','','zaproxy@example.com',0,1,'2023-07-05 21:09:56.721138','');
INSERT INTO "auth_user" VALUES (19,'pbkdf2_sha256$600000$eOXOiQdSruaUPB8sgINgBI$7khgzJZ4lYc12DX5ehfDLVpCWzIqDB92M5paza+7TXk=',NULL,0,'WEB-INF/web.xml','','zaproxy@example.com',0,1,'2023-07-05 21:09:56.905074','');
INSERT INTO "auth_user" VALUES (20,'pbkdf2_sha256$600000$E1e7Q0KJx3Tn3CguNxcAq8$1YnN5QOLEfbekLmKfhWZ8U8RZfq0md3q5ueESQQm0oY=',NULL,0,'WEB-INF\web.xml','','zaproxy@example.com',0,1,'2023-07-05 21:09:57.091789','');
INSERT INTO "auth_user" VALUES (21,'pbkdf2_sha256$600000$sLCEtueK0WSk3lvKYSjjPB$r2rCz/eQDezhz1dLdDkLTXQPmsf2c1gLAmpyL4ZSt2I=',NULL,0,'/WEB-INF/web.xml','','zaproxy@example.com',0,1,'2023-07-05 21:09:57.277303','');
INSERT INTO "auth_user" VALUES (22,'pbkdf2_sha256$600000$ONzvMzSsbb4iwAb7bHXFUB$BOJIQzBaC9GJ94Jt/dIXYzDGtKkB2zc7ezMPnUyW16g=',NULL,0,'\WEB-INF\web.xml','','zaproxy@example.com',0,1,'2023-07-05 21:09:57.464799','');
INSERT INTO "auth_user" VALUES (23,'pbkdf2_sha256$600000$wY94TIv8PrAwvn54G7PM2S$lwOgCvoaufWYohGv8kr+z6kZ37AIgjedWLkWXk2NV4E=',NULL,0,'thishouldnotexistandhopefullyitwillnot','','zaproxy@example.com',0,1,'2023-07-05 21:09:57.648640','');
INSERT INTO "auth_user" VALUES (24,'pbkdf2_sha256$600000$4Mc8KUhZH5GZhFof6vYvTu$2T+dkwBjWBFJuEz2ZgtF1FEyRpshU/7mvfNsDxaLX/E=',NULL,0,'http://www.google.com/','','zaproxy@example.com',0,1,'2023-07-05 21:10:08.497249','');
INSERT INTO "auth_user" VALUES (25,'pbkdf2_sha256$600000$yBgSwB3OXvmgwJjsUyJXtj$YaORkpjSu59lefSV8D5+LGYIOzRPNKB0IaGHi48/DCg=',NULL,0,'http://www.google.com:80/','','zaproxy@example.com',0,1,'2023-07-05 21:10:08.680267','');
INSERT INTO "auth_user" VALUES (26,'pbkdf2_sha256$600000$XL02l2U7vKaJaygmOQpJk8$rZ936eyiSscqyIgMmDlx0NsQG53ZSranLaQp2AdNDmY=',NULL,0,'http://www.google.com','','zaproxy@example.com',0,1,'2023-07-05 21:10:08.862750','');
INSERT INTO "auth_user" VALUES (27,'pbkdf2_sha256$600000$zD7F2SXl26Uo6zwppZx54y$zKH7l2ouN0K1T4X8biiD1sf14A/CEQOLtMebo3WVn84=',NULL,0,'http://www.google.com/search?q=OWASP%20ZAP','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.044925','');
INSERT INTO "auth_user" VALUES (28,'pbkdf2_sha256$600000$7iUy58MAeXFJ7zGOLBFRtw$KI7cXvs6+G9RmfBmj0dCe0ORT1TcMQSxvrwgJXjz+oA=',NULL,0,'http://www.google.com:80/search?q=OWASP%20ZAP','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.230117','');
INSERT INTO "auth_user" VALUES (29,'pbkdf2_sha256$600000$8O4UonArlU83CHRbQb3ajw$nqqbx+fby+yKit+W5R+XpOSHtPmucp2yocx5wkEjb0s=',NULL,0,'www.google.com/','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.415151','');
INSERT INTO "auth_user" VALUES (30,'pbkdf2_sha256$600000$z705JlL19tVLTtQeGv9zPW$IwEiqCyiRBJI5tNKFhg5MVSAOtclCI8h3Jboct7cNWk=',NULL,0,'www.google.com:80/','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.598307','');
INSERT INTO "auth_user" VALUES (31,'pbkdf2_sha256$600000$vBqkmpKBTMBS76n2uf7joP$naxHZycqQpnfSfRNpoxHaX9CW+b3y10IrN49TWknkpA=',NULL,0,'www.google.com','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.780462','');
INSERT INTO "auth_user" VALUES (32,'pbkdf2_sha256$600000$fcDlMtLRdgv61TPVfpgffE$SZyvMwQT+r4SjW7GffUvCR9R2OTxqBUtDLGooiyQzCg=',NULL,0,'www.google.com/search?q=OWASP%20ZAP','','zaproxy@example.com',0,1,'2023-07-05 21:10:09.963435','');
INSERT INTO "auth_user" VALUES (33,'pbkdf2_sha256$600000$hNlqiiDgft0nIrnT9OfWjc$BKrCL5uzeo6BNu39ZZSsM7tAuWbAOBLadoCnIr0zpqU=',NULL,0,'www.google.com:80/search?q=OWASP%20ZAP','','zaproxy@example.com',0,1,'2023-07-05 21:10:10.146617','');
INSERT INTO "auth_user" VALUES (34,'pbkdf2_sha256$600000$mVcyILPQwNgBdKPnxZ0wAW$koNl5Z7tAPCx+0Ujo0RLArvi+X7oV9RLD7wWkZUH7SE=',NULL,0,'6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:31.628220','');
INSERT INTO "auth_user" VALUES (35,'pbkdf2_sha256$600000$k5UEcXOeqLQsIIEYyJsdUh$2L7GLgMItiI/WAYV2lAPYEcYXG2hAUoZCSU9wCU/EFk=',NULL,0,'http://6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:31.721978','');
INSERT INTO "auth_user" VALUES (36,'pbkdf2_sha256$600000$9admC2BS2O6qOfpFeemkbO$1lVnsFJo01koz/lDohazNl/NqkJ1GsUWBIBEGtkHu9s=',NULL,0,'https://6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:31.812809','');
INSERT INTO "auth_user" VALUES (37,'pbkdf2_sha256$600000$TofA1dRyjLndL8fzAYE1rO$lB9ZO5KgaIF22ciTAGe0U1F72Xz5Hk2VqtsFMViDlYM=',NULL,0,'https://6897079771569763250%2eowasp%2eorg','','zaproxy@example.com',0,1,'2023-07-05 21:10:31.904429','');
INSERT INTO "auth_user" VALUES (38,'pbkdf2_sha256$600000$2G3sXiZfRTWt2BFQOHlTBl$L1NoKTQMZuG2koTOK41gF+zJnlVm2t7mH6xnYvWh1fU=',NULL,0,'5;URL=''https://6897079771569763250.owasp.org''','','zaproxy@example.com',0,1,'2023-07-05 21:10:31.996089','');
INSERT INTO "auth_user" VALUES (39,'pbkdf2_sha256$600000$fcEoWaaVDH9wGrouIX0nPP$hYadvH7GlitT3331XvN3pM6bDWcG4D7TGC587xM+fZs=',NULL,0,'URL=''http://6897079771569763250.owasp.org''','','zaproxy@example.com',0,1,'2023-07-05 21:10:32.088324','');
INSERT INTO "auth_user" VALUES (40,'pbkdf2_sha256$600000$8lBO6QSdi6tkXsW0NMP2nL$ktfHpGrkDabeKi47b8p52/kUIf6xzFpe4GtWOaAvyi8=',NULL,0,'http://\6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:32.180793','');
INSERT INTO "auth_user" VALUES (41,'pbkdf2_sha256$600000$5sD5T52jkpv0Heyq9a53au$D+m3qIYMsmbkqTgVr84ISiHFm3tYRew7ZzsWN2MxvNo=',NULL,0,'https://\6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:32.274027','');
INSERT INTO "auth_user" VALUES (42,'pbkdf2_sha256$600000$De5KpdUIzlDNSkR4vQ2hwe$ewH8kyIbVnZyQW2QB3wh0Cb26yd++kyet0N7iBYtGlA=',NULL,0,'//6897079771569763250.owasp.org','','zaproxy@example.com',0,1,'2023-07-05 21:10:32.366485','');
INSERT INTO "auth_user" VALUES (43,'pbkdf2_sha256$600000$ekHUMvCGEKDr9CqxaoCyrm$VGABK2/JZVAkqlyyEDnADvgCqow4DcD+XXc6Xgj4T0A=',NULL,0,'<!--#EXEC cmd="ls /"-->','','zaproxy@example.com',0,1,'2023-07-05 21:10:40.917892','');
INSERT INTO "auth_user" VALUES (44,'pbkdf2_sha256$600000$snub28t1ee4oarBq4DnUct$dwBiVrO75R3uvDR8aDv2fHklF6HryB5ZwQ2i+JQNKRU=',NULL,0,'"><!--#EXEC cmd="ls /"--><','','zaproxy@example.com',0,1,'2023-07-05 21:10:41.104336','');
INSERT INTO "auth_user" VALUES (45,'pbkdf2_sha256$600000$KxsfeTR6hcwQHr5MN0EXAE$0CTMoEg2C+ZqQH/oTg/Exa8wNMwy1qQcP51dTg0U2qU=',NULL,0,'<!--#EXEC cmd="dir \"-->','','zaproxy@example.com',0,1,'2023-07-05 21:10:41.292877','');
INSERT INTO "auth_user" VALUES (46,'pbkdf2_sha256$600000$peh90DhsMnGxQuWFGZ3uoX$YLMhaNz3y3F7fuRxuyESRBRQe+GNQgPlML4bzP4Ca4s=',NULL,0,'"><!--#EXEC cmd="dir \"--><','','zaproxy@example.com',0,1,'2023-07-05 21:10:41.485306','');
INSERT INTO "django_session" VALUES ('u761teybjemsqq3xbb5b6w5fs052r149','.eJxVjMsOwiAQRf-FtSHg8HTp3m8gAwxSNZCUdmX8d9ukC93ec859s4DrUsM6aA5TZhcG7PS7RUxPajvID2z3zlNvyzxFviv8oIPfeqbX9XD_DiqOutXJGSjOFWUjaQNQNGKWzpOTiIK8TtJGOOfiwUlJYEVSJXkjQBa1lezzBeerN7c:1q7F8R:TajFl_VFc68NtQInV1CWqMOL7z_oOHF3mv_ar_CtL0w','2023-06-22 12:53:03.946213');
INSERT INTO "django_session" VALUES ('89kq7kzxt0z1n98jqptzsskksht4icol','.eJxVjDsOgzAQBe-ydWRhgxebMn3OYK2965h8QMJQRbl7gkRD-2befOAtlWCwFwi0rSVsVZYwMgyg4bRFSk-ZdsAPmu6zSvO0LmNUu6IOWtVtZnldD_cUKFTLnjVoLFNPrsHkXLYeu0yOvbSmTYgm2g5Zs2Sk1uucvG8I5f_KfS8W4fsDka46Fg:1qA8cA:-oIqIYYH1lkyl_MYlfBd2yCxxZay0hvqR-CK38XQ3nk','2023-06-30 12:31:42.520469');
INSERT INTO "django_session" VALUES ('5kzo593vb9nqjo2uuzsega0zylrbrl93','.eJxVjDsOgzAQBe-ydWRhgxebMn3OYK2965h8QMJQRbl7gkRD-2befOAtlWCwFwi0rSVsVZYwMgyg4bRFSk-ZdsAPmu6zSvO0LmNUu6IOWtVtZnldD_cUKFTLnjVoLFNPrsHkXLYeu0yOvbSmTYgm2g5Zs2Sk1uucvG8I5f_KfS8W4fsDka46Fg:1qCpWF:VMyAJv7tIss2OClCS8HhAblP6EKdx0AaS23K2v9D_kI','2023-07-07 22:44:43.666218');
INSERT INTO "django_session" VALUES ('95ffq0bde7i70tkql2r9kabjy9b7oms6','e30:1qDWNY:q_uVLBEtjlnlXC0eokc8JLmz9XFSGuzN5udrFzc5hHQ','2023-07-09 20:30:36.463889');
INSERT INTO "django_session" VALUES ('ffxmpzhf36c2c3ud34s3br57m51dvy2h','e30:1qDWOR:qVP-jdzPnn5OKgqse7abqWSCIXstCtneAgY39DKucr0','2023-07-09 20:31:31.267191');
INSERT INTO "django_session" VALUES ('irh91h51h59k4ocfi0fdr31efipjiy1y','e30:1qDWQ9:ZHOU3XKz296P1FeX1RqZaMugwhgL6wwDsKXcg-uOnso','2023-07-09 20:33:17.501620');
INSERT INTO "django_session" VALUES ('vcjum29xlkxymgrec8zkh6i04lrarpd1','e30:1qDWQF:GOqlDTrswhXFWylNoI02ID7l0TkhM5UctEgQ9TQaFNE','2023-07-09 20:33:23.696360');
INSERT INTO "django_session" VALUES ('9prhwwg8nt6p994bzb9b751vrux0cmp1','e30:1qDWQp:HmMeVzsVn3jpfGHiuco59I_IppT5BWHAyCSU9icTTOU','2023-07-09 20:33:59.348562');
INSERT INTO "django_session" VALUES ('i4hrotnfa2n2p69qeoovxpum2khqceee','e30:1qDWUM:Xp2VRZAbjvUmPBYqbL8bIgns2KiY1frafUbnouvhhz4','2023-07-09 20:37:38.004593');
INSERT INTO "django_session" VALUES ('9zu2hxf7lxxb7q3sjfscs3og0lcvs9d6','.eJxVjDkOwjAUBe_iGlmOF6xPSc8ZrL_YOIAcKU4qxN1JpBTQzsx7b5VwXWpae57TKOqiojr9MkJ-5rYLeWC7T5qntswj6T3Rh-36Nkl-XY_276Bir9u6ZB9dYTYoNCCCIesogwne8jmGQMECAgiBI4cwQPEeN8qWWIxj9fkCAwg4hg:1qDsGr:81SZWDLOthKwUAP-OJ1M-OAFLabeRzfhVmrkJJEz9_Q','2023-07-10 19:53:09.737413');
INSERT INTO "django_session" VALUES ('o10p6hc52qmxxw8gfs9luqyx2u9edk6q','.eJxVjDsOgzAQBe-ydWRhg9c2ZfqcwVq865h8QMJQRbl7gkRD-2befOAtlaB3F4i0rSVuVZY4MvSg4bQNlJ4y7YAfNN1nleZpXcZB7Yo6aFW3meV1PdxToFAte9agsUyOfIPJ-2wDdpk8B2lNmxDNYDtkzZKR2qBzCqEhlP8rOycW4fsDkwY6GA:1qEG9Y:Jsa9g3BkmQR8YrEsTp8FPh7NmkYsdT8rcZQtU91LH1U','2023-07-11 21:23:12.457518');
INSERT INTO "django_session" VALUES ('j0lsmo0tuws17ice808klt01su7d1j3i','.eJxVjEEOwiAQRe_C2pACZQCX7j1DM2UGqRpISrsy3l1JutDtf--_l5hw3_K0N16nhcRZKHH63WaMDy4d0B3LrcpYy7Yus-yKPGiT10r8vBzuXyBjyz2rQVtCh36A6H2yAcaEngIbbSKAnu0IpIgToAkqxRAGBP6-knNsQbw_0yI3kQ:1qEGCp:pQhYA9Rcdi0t04TetvTefpibbxDgRmU1CzBRdKSntYI','2023-07-11 21:26:35.068444');
INSERT INTO "django_session" VALUES ('b07f6m5x7db8r4c9zqnjqd5yskfgfnvi','.eJxVjDsOgzAQBe-ydWSBP4tNmT5nQGvvOpCPkTBUUe6eINHQvpk3H3hLJejtBQba1nHYqizDxNBDC6ctUnpK2QE_qNxnleayLlNUu6IOWtVtZnldD_cUGKmOe1ajdkwd-QaT99kFtJk8BzHaJEQdnUVuWTKSCW1OITSE8n_lrhOH8P0BkQI6FQ:1qGmNV:UtEmXc95KBryh8FmkYEqCwbyYnip7JPAlCRpebH_zOA','2023-07-18 20:12:01.201285');
INSERT INTO "django_session" VALUES ('c0q11rdu1b32pb55poezmei7n1ieuatq','eyJtZXNhIjo1fQ:1qH9KJ:BWc9OzlhCU4MCD6kafxzr63S7Fm8R0vPejlSGtqgbFU','2023-07-19 20:42:15.336351');
INSERT INTO "django_session" VALUES ('7w7p79b69ylv0yn8zpojhzgmjead1781','.eJxVjDsOwyAQBe-ydYQwHwMu0-cMaFk2sfMBydhVlLvHlty4fTNvvvDhhjDYC0RclzGujec4ZRjAw2lLSC8uO8hPLI8qqJZlnpLYFXHQJm418_t6uKfAiG3c3pRVIicVEUnT9YZYe3SapAvs1N2h7LELvQ3GspSeui2Nm-tDUqitgd8frVU6cw:1qH9KL:m8KWp3-gf49TplFCCE3dAEi-Ys9b1Y_9NGiRij3evB4','2023-07-19 20:42:17.091738');
INSERT INTO "django_session" VALUES ('6w07z7m2wbxh9j0uet38i606afsq643a','e30:1qH9KK:c7u9VYvMn3jTecGGoPxF6UUET97rewxIL3lY4MnuBSs','2023-07-19 20:42:16.992121');
INSERT INTO "django_session" VALUES ('52dfuhrr8jjlj87o76tiiodbposzmxs9','eyJtZXNhIjo1fQ:1qH9La:YBuhcXvi6A2pUvrjUneE4qj97XWbSWAiBfXYl-z3PpM','2023-07-19 20:43:34.664855');
INSERT INTO "django_session" VALUES ('cnypj0u0obhr5lxh2jvtvmq1qcq1wseu','eyJtZXNhIjo1fQ:1qH9Lb:eyPeRkk1G9yYOWWL765lihGxVYi_GEN7ONp2_9Tnl6s','2023-07-19 20:43:35.170812');
INSERT INTO "django_session" VALUES ('h2vcv2jgsdz6p9gjmwuc58h995fxtl1g','eyJtZXNhIjo1fQ:1qH9Lc:-S_ANtRxhxHp9m_bookbu-FzoFiP6A_9GstC9LqNw5I','2023-07-19 20:43:36.281043');
INSERT INTO "django_session" VALUES ('l0gfaglgu434g11tfvsmxti0e046227i','eyJtZXNhIjo1fQ:1qH9Lc:-S_ANtRxhxHp9m_bookbu-FzoFiP6A_9GstC9LqNw5I','2023-07-19 20:43:36.479945');
INSERT INTO "django_session" VALUES ('4da1fxfj7525xjrt4rtqecz3afb9sgpj','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.435123');
INSERT INTO "django_session" VALUES ('tnki0ysv9y0flclw7l1hjnc3whtzdy1o','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.440784');
INSERT INTO "django_session" VALUES ('6n6aqmacx8jzj3ygsik9x9d7s2pk49i7','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.443763');
INSERT INTO "django_session" VALUES ('a4e5aim78kufn0v6rkse1i6mxnxg8wgm','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.449639');
INSERT INTO "django_session" VALUES ('sik8k45s951r3e5el37wqtm5ee3gp6zo','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.454556');
INSERT INTO "django_session" VALUES ('pb4mxaamm6pwuma5ykas37ju7jwbmk44','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.463743');
INSERT INTO "django_session" VALUES ('ha9ke739yr9x7idqgzgwwy64ann23k0k','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.474216');
INSERT INTO "django_session" VALUES ('zh3yp7o57aac0l5n8y5aazhsjkwe4te8','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.478871');
INSERT INTO "django_session" VALUES ('6vkdogjh9a2f6gitidl0pvaabk2zispn','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.483983');
INSERT INTO "django_session" VALUES ('r6bunzqmacyuque7wjgnn7d66palgfaa','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.493718');
INSERT INTO "django_session" VALUES ('u1m178etjwchvvvzpcnmp33bvsf32f8l','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.501201');
INSERT INTO "django_session" VALUES ('mzol04vho52ajwaog8jz08twatlnmw78','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.508694');
INSERT INTO "django_session" VALUES ('czh5g1xy8lsd7kkr16enz5way9nl5p9c','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.508887');
INSERT INTO "django_session" VALUES ('ek3l2w7d919avgpz4gr5rkcmcutixhwz','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.513961');
INSERT INTO "django_session" VALUES ('0nfgumjukgew8jlp9lbcs7m0fe69jztf','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.519052');
INSERT INTO "django_session" VALUES ('2h5mskugpvppw2sgu0zc3ixxf10c420j','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.528745');
INSERT INTO "django_session" VALUES ('0i3zutqceimqq7bbv9o1l03r4wdni0k5','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.547785');
INSERT INTO "django_session" VALUES ('t7yuynf0sicg18rdlb2q3ipvguyge96k','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.562887');
INSERT INTO "django_session" VALUES ('7c0fzo42w0whb9f6adupl7waqpmoh70h','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.576823');
INSERT INTO "django_session" VALUES ('vhfqhsiop3mdydvch0cdau49pvytv5i1','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.593543');
INSERT INTO "django_session" VALUES ('uhhwaw122pn3t34fce9erkq2k1m0bplr','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.610363');
INSERT INTO "django_session" VALUES ('ljf7o06zajdrzgpr6q7feunwf6w0fbxa','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.624331');
INSERT INTO "django_session" VALUES ('jxaq58ps26kg0hywtrm4ube2jckjm7n2','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.640906');
INSERT INTO "django_session" VALUES ('w8n7s9wg5acaffhkto2j80iff63nppii','eyJtZXNhIjo1fQ:1qH9Ld:1vVG-4BQzXyEuj1E5AWbH_ROZ6qH4U2_7Kl8W94HBK4','2023-07-19 20:43:37.654682');
INSERT INTO "django_session" VALUES ('h6u2xerkbk9qla479wk8xobw9f84k34u','eyJtZXNhIjo1fQ:1qH9M4:CpObvI3P1tGlGDv3HEYOkfNHvR-zMhqcqDIYh0mR9ro','2023-07-19 20:44:04.636904');
INSERT INTO "django_session" VALUES ('od6ycham8g3q74dxogmjdpyhohul0idk','eyJtZXNhIjo1fQ:1qH9Md:2NPKPAsSwU9SP0R-uFb0zz_AX-HNCIxaxLnDWtjVcKQ','2023-07-19 20:44:39.838361');
INSERT INTO "django_session" VALUES ('bjo3ellzbqgx6lf2ylhxn780505apss8','eyJtZXNhIjo1fQ:1qH9NW:pmIL9gZL9swADgIJeiklMhxZFeis1iLfsCRfm-n6LeY','2023-07-19 20:45:34.137357');
INSERT INTO "django_session" VALUES ('x8g7598vg75b39zpacz5vf3tetilhw6c','eyJtZXNhIjo1fQ:1qH9NS:F-HXotmm3zamQ6gf1JMZlCAXTb3D4-Ij0RkR4MWMRgo','2023-07-19 20:45:30.690163');
INSERT INTO "django_session" VALUES ('27jlnrueqpv5yukyxn3l59nod2dngivr','eyJtZXNhIjo1fQ:1qH9NV:ZLza7iC4zGK4Ed6Ki4n6uRYKPIUfEbdpBg5MpDB08D0','2023-07-19 20:45:33.792014');
INSERT INTO "django_session" VALUES ('uc7zilp7i06cnfhs2zd9xvg3tojk3tpm','eyJtZXNhIjo1fQ:1qH9NT:CgHMvlz7FOArQsfNXgJOzkbfD8PMd1TMpyPttUDUikc','2023-07-19 20:45:31.118347');
INSERT INTO "django_session" VALUES ('6jfiqtsce0dh8aaa3dgslajgmjdnsnho','eyJtZXNhIjo1fQ:1qH9NS:F-HXotmm3zamQ6gf1JMZlCAXTb3D4-Ij0RkR4MWMRgo','2023-07-19 20:45:30.406585');
INSERT INTO "django_session" VALUES ('duxgji4pod4be645z1tveh07vyxa66r5','eyJtZXNhIjo1fQ:1qH9NS:F-HXotmm3zamQ6gf1JMZlCAXTb3D4-Ij0RkR4MWMRgo','2023-07-19 20:45:30.870067');
INSERT INTO "django_session" VALUES ('oe25xwx3xv5c7q0acq5hjqfk8crfvii2','eyJtZXNhIjo1fQ:1qH9NS:F-HXotmm3zamQ6gf1JMZlCAXTb3D4-Ij0RkR4MWMRgo','2023-07-19 20:45:30.595874');
INSERT INTO "django_session" VALUES ('3rg29v0kynrssb2udotsbrnh2wk29yx7','eyJtZXNhIjo1fQ:1qH9NR:me0sMf7IakJLoKyAzgsh-HB_cDqfQPr4mXepZXRN_-w','2023-07-19 20:45:29.022995');
INSERT INTO "django_session" VALUES ('9j0pocq69hn1wwxe8sb4zjgo2kk2i92f','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.645650');
INSERT INTO "django_session" VALUES ('6dlcxuwkvvming9xjst5223pyhb4jfns','eyJtZXNhIjo1fQ:1qH9NM:nsHgjM2DzvoJGWwDY9YI659H_JDJly3NzCvDf3culbk','2023-07-19 20:45:24.035779');
INSERT INTO "django_session" VALUES ('hjnt5qcqw9y42zuimse22058c4ppe4wf','eyJtZXNhIjo1fQ:1qH9NR:me0sMf7IakJLoKyAzgsh-HB_cDqfQPr4mXepZXRN_-w','2023-07-19 20:45:29.737447');
INSERT INTO "django_session" VALUES ('kgj818e6mh27kz2lfvbsdbk6n7rcbxqn','eyJtZXNhIjo1fQ:1qH9Nt:PA9Nf-UjDCP5_hJFbPiNEe_hZknQwuHX20JE0O1GgRY','2023-07-19 20:45:57.910262');
INSERT INTO "django_session" VALUES ('9lfbs46axqs2j5kpk91autsol68ni1xe','eyJtZXNhIjo1fQ:1qH9Nu:ASz4VVfPEMvtzJB4FNdE_eju_LKh358cTJ6yb-fr6HI','2023-07-19 20:45:58.755747');
INSERT INTO "django_session" VALUES ('cl6rzb2boukpwg1n3j0hnw83pnv4ex15','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.570258');
INSERT INTO "django_session" VALUES ('zjxbctivjbff4mf8qz46i40ocs301bhb','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.610222');
INSERT INTO "django_session" VALUES ('t0m3c2cqcvzimblnbqvotnilixe15sx5','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.642276');
INSERT INTO "django_session" VALUES ('85vh8fffwwql97bf60ya6v8roizto7uu','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.666940');
INSERT INTO "django_session" VALUES ('cusc44eq91uiv8lxtc7rwibi62iwzkoj','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.681356');
INSERT INTO "django_session" VALUES ('bvjtmakn558r5p05wejeiasrv8agefj6','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.691854');
INSERT INTO "django_session" VALUES ('xqgrfuye499k7irtnhcreza2y2r3n6qd','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.701089');
INSERT INTO "django_session" VALUES ('5rj2bpkvr5ntzpj9l1ndbl03lcelo94p','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.710477');
INSERT INTO "django_session" VALUES ('4r9ue1tqtsm1yzilhp5c5n2m87i9uwv1','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.719959');
INSERT INTO "django_session" VALUES ('lly6ce4e4fyahnt8nh4fd5iuob5huwrm','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.731486');
INSERT INTO "django_session" VALUES ('52uj3dy2b0wx8azzdu7sxtno1hjo2er3','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.749920');
INSERT INTO "django_session" VALUES ('8sifeli5jwvqgwsrhmgd76xn7wegid6f','eyJtZXNhIjo1fQ:1qH9Nv:kgpLZBn9-SXTyO4Tgzi5Ez86UJFsTwqLIA5aO344yiY','2023-07-19 20:45:59.765790');
INSERT INTO "django_session" VALUES ('u1bd54sx3w4kes9bxpgffnm0ji5sx8e4','eyJtZXNhIjo1fQ:1qH9P2:AYLBIWxORZxYTOseYQweQofmToOaxOsZtBYA42vf_UA','2023-07-19 20:47:08.003456');
INSERT INTO "django_session" VALUES ('loz8wf0rjsiw98n6cihenb5a1gr0iilh','eyJtZXNhIjo1fQ:1qH9P4:Q_6pviizBtlUEilhZBuJ9dUeHHrdUR5U4VHM118feqE','2023-07-19 20:47:10.489205');
INSERT INTO "django_session" VALUES ('vfbfohhue3zcqv420p4pvvrwv9p88m5k','eyJtZXNhIjo1fQ:1qH9P6:IPezrxVnlpvjhvaUPt34THTXKdTiGej1SPFNVk2RdiM','2023-07-19 20:47:12.649108');
INSERT INTO "django_session" VALUES ('s1b7mq485olvzs7ye80a0htxwkn1lkv1','eyJtZXNhIjo1fQ:1qH9Q3:MZKpSYBv8FLBbW9XgA68kuFU5XTzQQUOn5tYfMcQgFs','2023-07-19 20:48:11.588194');
INSERT INTO "django_session" VALUES ('gg9p161qlr9rkl8ucye17yfysbe6e8f4','.eJxVjDsOwyAQBe-ydYQwHwMu0-cMaFk2sfMBydhVlLvHlty4fTNvvvDhhjDYC0RclzGujec4ZRjAw2lLSC8uO8hPLI8qqJZlnpLYFXHQJm418_t6uKfAiG3c3pRVIicVEUnT9YZYe3SapAvs1N2h7LELvQ3GspSeui2Nm-tDUqitgd8frVU6cw:1qH9Q4:1WLOruE7mD2UKVy6Cv6t-pTqIbTsWiCkXQDsQ-5HIwc','2023-07-19 20:48:12.055209');
INSERT INTO "django_session" VALUES ('hkn5lq8it3rn44iteafzl9fzrpl8mf2s','e30:1qH9Q4:EgpRC7HUMpR_58jxyTD4GBw-cxUFh07FD918DIiBSK0','2023-07-19 20:48:12.140578');
INSERT INTO "django_session" VALUES ('dk2w7zkpevce7lltrif3g5qwo0gtdaat','eyJtZXNhIjo1fQ:1qH9QQ:F9EzR6tDQ95Og1TYtTLSkYczS7tyhq46bwn6gYd27cE','2023-07-19 20:48:34.050786');
INSERT INTO "django_session" VALUES ('d5lrj6c6ck3s9ttpkquwqln6uftwri6b','eyJtZXNhIjo1fQ:1qH9QQ:F9EzR6tDQ95Og1TYtTLSkYczS7tyhq46bwn6gYd27cE','2023-07-19 20:48:34.264133');
INSERT INTO "django_session" VALUES ('285k93z8i31aq2t8f20w7f3p6u9pdyi6','eyJtZXNhIjo1fQ:1qH9QQ:F9EzR6tDQ95Og1TYtTLSkYczS7tyhq46bwn6gYd27cE','2023-07-19 20:48:34.801114');
INSERT INTO "django_session" VALUES ('63ivh31p7rm9fmv3q72o1dv5rttj76ny','eyJtZXNhIjo1fQ:1qH9QQ:F9EzR6tDQ95Og1TYtTLSkYczS7tyhq46bwn6gYd27cE','2023-07-19 20:48:34.998186');
INSERT INTO "django_session" VALUES ('ti3566yhi4zkl7wizxsxzpk8962ryehy','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.448553');
INSERT INTO "django_session" VALUES ('vwhj1ueai51y7bsig083qxeeivsh7t7j','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.456036');
INSERT INTO "django_session" VALUES ('2ayhftueay2yzzvpp3jtuwg1cf9j5lzz','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.456237');
INSERT INTO "django_session" VALUES ('epnp7mzkgwzte9b45931empe8xgmyoi0','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.461567');
INSERT INTO "django_session" VALUES ('fyc9f7feq5jkw938dgl4spe8dnn3ndyg','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.465894');
INSERT INTO "django_session" VALUES ('468t9a4okytbq7sbyxsv87t5cid14m0o','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.470308');
INSERT INTO "django_session" VALUES ('4c0dvuo7lnseqfkcovi2obhwxlca861z','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.477429');
INSERT INTO "django_session" VALUES ('h3o2oybphgawhuqc8o0e8fc1qdysmm84','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.484752');
INSERT INTO "django_session" VALUES ('2uhl9rs7o7in1zdfgmilroxakcueypn4','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.484981');
INSERT INTO "django_session" VALUES ('y5hb4m6c92zn8fwdc69bn448ndzq0qhr','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.490139');
INSERT INTO "django_session" VALUES ('dhh49u1jv6g2j8j7t3mfzl0fw8h2iihn','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.494564');
INSERT INTO "django_session" VALUES ('83xwb4g4ahlplvs7wz3bfxvgh0ra2erz','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.499121');
INSERT INTO "django_session" VALUES ('ibisdlb8hpvn128rvuzlb79opuambyda','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.503981');
INSERT INTO "django_session" VALUES ('kbvc0o0woz1dbq0bh327epfzeyfggrec','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.509737');
INSERT INTO "django_session" VALUES ('jt8ypgmtydaf1i8ts8te04nqzmmnmwaw','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.515354');
INSERT INTO "django_session" VALUES ('4fhbihx9kcjgygr7i7tymx4qkfy3d9f9','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.533997');
INSERT INTO "django_session" VALUES ('pnqmo7qp0fx9ukj4yp3royu8c6pmg7s7','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.550185');
INSERT INTO "django_session" VALUES ('8m7rx349fr71r45lhm9lee0h2ukwbxoe','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.564177');
INSERT INTO "django_session" VALUES ('sjtyj4odhuabihz5i0w99ubs03qnxktp','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.578275');
INSERT INTO "django_session" VALUES ('2ejx33thbb9nxtu0fd5x7l3fq4j0d371','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.592052');
INSERT INTO "django_session" VALUES ('t62m3pkp029csa3molazjg89rnhg7p0f','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.604627');
INSERT INTO "django_session" VALUES ('ktz8ugxypzv35bihmq2c2pyj881mpuak','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.617303');
INSERT INTO "django_session" VALUES ('xy02bxjbzvl4i1mygdnbb35iyzreho4t','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.632452');
INSERT INTO "django_session" VALUES ('ui1nvdlu5v4nyknfmp4qgreth7kg9pyw','eyJtZXNhIjo1fQ:1qH9QR:1tnxd5GS_GisanxKROgAggfyz0yI7G8vQha--8VolFo','2023-07-19 20:48:35.646099');
INSERT INTO "django_session" VALUES ('9sqskilfje0idaswkg0neqcperpfuwsu','eyJtZXNhIjo1fQ:1qH9cc:GHYVomn6RT0x4yx-QGTQnBBe_jjzuudXQ-R1mZFJs9Q','2023-07-19 21:01:10.803357');
INSERT INTO "django_session" VALUES ('hzqbmylbrfy3zxp215xxlvpmhxl8b9jf','eyJtZXNhIjo1fQ:1qH9cp:mtIhlYTJFrDutAGmjIwIZAqnq31Ti-K7hwqHTEt0WsE','2023-07-19 21:01:23.230488');
INSERT INTO "django_session" VALUES ('n66jxd3bsxnj7f0hxafsbvci1lzcbs71','eyJtZXNhIjo1fQ:1qH9dS:sN6JVbytTDc3In5bpCfYO-_KJGNa5gYo3RNGAxv47lM','2023-07-19 21:02:02.344114');
INSERT INTO "django_session" VALUES ('yovrpn4uzzcuusr3bdepaunj0ckf0qpa','eyJtZXNhIjo1fQ:1qH9dS:sN6JVbytTDc3In5bpCfYO-_KJGNa5gYo3RNGAxv47lM','2023-07-19 21:02:02.304109');
INSERT INTO "django_session" VALUES ('7575efmabo6svit8yr872lmogahxw858','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.446130');
INSERT INTO "django_session" VALUES ('df5gnkr0m2uargp99840pqzmtr1zm2p2','eyJtZXNhIjo1fQ:1qH9dN:TcY5TjQA8HvkNguIS2HyM-JzlGAl4ea8oi4yWlQpbWw','2023-07-19 21:01:57.459651');
INSERT INTO "django_session" VALUES ('uox86y7hzhikh8yjy3tktwrwbak2p05z','eyJtZXNhIjo1fQ:1qH9dS:sN6JVbytTDc3In5bpCfYO-_KJGNa5gYo3RNGAxv47lM','2023-07-19 21:02:02.159440');
INSERT INTO "django_session" VALUES ('mdmifc97tk3307bhiocyobjr8k4g287v','eyJtZXNhIjo1fQ:1qH9dR:4r13P0y-4gcMrCXTYWdeJfFlvv21Zf8XL4WoQ_tLSh0','2023-07-19 21:02:01.262603');
INSERT INTO "django_session" VALUES ('hpn712o8k06ff16iqf2odmsrwi32wrj2','eyJtZXNhIjo1fQ:1qH9dS:sN6JVbytTDc3In5bpCfYO-_KJGNa5gYo3RNGAxv47lM','2023-07-19 21:02:02.732594');
INSERT INTO "django_session" VALUES ('p1et820eriv5xex9bewr3xprqtxilubf','eyJtZXNhIjo1fQ:1qH9dR:4r13P0y-4gcMrCXTYWdeJfFlvv21Zf8XL4WoQ_tLSh0','2023-07-19 21:02:01.738875');
INSERT INTO "django_session" VALUES ('vzjyw4hw0efiw2aq7na3578ign2gf02r','eyJtZXNhIjo1fQ:1qH9dQ:UIfqHbVhJIWlIdmb9fQSiU8ETHsXdYyGx2rSAgmIoVo','2023-07-19 21:02:00.206002');
INSERT INTO "django_session" VALUES ('qf5po976xgymr2x9fvz6eteqlje4lv7o','eyJtZXNhIjo1fQ:1qH9dV:oZXXRMRX5tMfqTqqsmuCD7Jy8g6Nswy4kkvA0kzxdFs','2023-07-19 21:02:05.515759');
INSERT INTO "django_session" VALUES ('09rwzlepov87p7yps9wyxr46iktcudy7','eyJtZXNhIjo1fQ:1qH9e5:NEg9uyHW7_gkcKorSQbSQyQeVVzuGYyzAdwNP5sgHgs','2023-07-19 21:02:41.144653');
INSERT INTO "django_session" VALUES ('sbw5k79b3bgi95cvcmpt94uuuxdrrgym','eyJtZXNhIjo1fQ:1qH9e5:NEg9uyHW7_gkcKorSQbSQyQeVVzuGYyzAdwNP5sgHgs','2023-07-19 21:02:41.721395');
INSERT INTO "django_session" VALUES ('ap9d7kpv8vhzjm3145a4jjofs6mbnxx5','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.387574');
INSERT INTO "django_session" VALUES ('vu0rsw0k5u3rrg8u1qxjztrwe33m65gr','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.415387');
INSERT INTO "django_session" VALUES ('ih0nj9unlqwl1h664qdb6nkihornvthr','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.432792');
INSERT INTO "django_session" VALUES ('aehp0abtjjf4625jccy2ny9dqno8jp42','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.457451');
INSERT INTO "django_session" VALUES ('hkk7bxjj8ye3zsvo00p8bn0py0w5bepo','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.479578');
INSERT INTO "django_session" VALUES ('ajj2aigz9rcps9veonbqe853wnb2045v','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.494497');
INSERT INTO "django_session" VALUES ('5902536iwhmtea7pb847zn6ilc1ohqnp','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.509737');
INSERT INTO "django_session" VALUES ('737fuo9l5zkkfqc8i9u9g586ej3h5osa','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.521490');
INSERT INTO "django_session" VALUES ('evq9rcfa9p1h2ozd1ia2l32qxgra0yzm','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.535533');
INSERT INTO "django_session" VALUES ('utwesdew7sxb3vvs4or3arv66dw3szv8','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.548345');
INSERT INTO "django_session" VALUES ('2yutuf9he7m98o8mty37cyo3y06w8wnf','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.561612');
INSERT INTO "django_session" VALUES ('d79pi2dx3jx37ppq15ee7khu0sebbhes','eyJtZXNhIjo1fQ:1qH9e6:ze7GW3hXkTOhNIgUarXas-9CbBaL3uI4PUbW7a5gxNs','2023-07-19 21:02:42.575408');
INSERT INTO "django_session" VALUES ('qwqhsznygyllw2p3us9p1i9g2rkt1gck','eyJtZXNhIjoxMDI0MDM1NzYxNDMzNDQ0MDU0fQ:1qH9l4:l1Q1hS3WHRr8GajrojrMf1nm2P6Le1hXtl630uQ95qg','2023-07-19 21:09:54.584807');
INSERT INTO "django_session" VALUES ('vgf4rmdnrj3oo86b5onpezswi7pry7ny','eyJtZXNhIjozMjI1NTQyMTQ0Mjc4NTkzMDQwfQ:1qH9l4:uwdXHyINfktzXWh28Oa1TdcloXmcK5IgCq75rpl5aeU','2023-07-19 21:09:54.596676');
INSERT INTO "django_session" VALUES ('5mmhlmjybwi1fou426lz7srafo6d4t5b','eyJtZXNhIjo1fQ:1qH9lU:9a4OTePcpd-uhp7IBxYMpiT-n8Xj2ota4AuRrAhAfCg','2023-07-19 21:10:20.577611');
INSERT INTO "django_session" VALUES ('20qvq6l8me9hwvick37nufbojqgl8v1e','eyJtZXNhIjoxfQ:1qH9qp:dIKmuci0dDflNr7jRR-XRLtW1JP8NNgO3twhVtvg2Y4','2023-07-19 21:15:51.734908');
INSERT INTO "django_session" VALUES ('ll4c66zbgno5mw05tqwe4e059vid0bly','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.880506');
INSERT INTO "django_session" VALUES ('xkwv2t77ycx3dtux9el68zdj0y5p4t9q','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.369154');
INSERT INTO "django_session" VALUES ('06kz16o6b5kvxwyqfkrefccbjveno9mg','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.972412');
INSERT INTO "django_session" VALUES ('pvcmda5z2r05on3tl3pgf1oxley3q6dt','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.276130');
INSERT INTO "django_session" VALUES ('obmrwckzdirjv3u1o6vgsnz8qcwc55cx','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.142430');
INSERT INTO "django_session" VALUES ('ap9wdm9qm0l4owfqsafsc418spntlvnp','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.194876');
INSERT INTO "django_session" VALUES ('6xot5bnr736295r7omr0v6sx9qku9h46','eyJtZXNhIjoxfQ:1qH9rJ:bgOq8lC1v8n-3B6JzdXQyK7XUQKU5_bF6k__YV0hwAk','2023-07-19 21:16:21.608544');
INSERT INTO "django_session" VALUES ('cb59jxmgmkxftxegg7n3pbuir23964yq','eyJtZXNhIjoxfQ:1qH9rL:8ocS1YP-4IH6yXnKsRTfthswcI_QRqrSP5Sb8wNK6-M','2023-07-19 21:16:23.184330');
INSERT INTO "django_session" VALUES ('mob7wa7yq3x8qur4krkqf372ntozpycf','eyJtZXNhIjoxfQ:1qH9rM:QeRzoESce7OAJrIdS9mWr4pJjY4aou9_t2eL2yqxOtw','2023-07-19 21:16:24.119115');
INSERT INTO "django_session" VALUES ('ypokbynf1ftshqq5loy13wmvrxfp8w62','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.210948');
INSERT INTO "django_session" VALUES ('uowk197syk6sa3ezdtyledr070of3fpl','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.191028');
INSERT INTO "django_session" VALUES ('yzxr5ocgoyiyahv1kv4t5ivpsoetvq50','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.204440');
INSERT INTO "django_session" VALUES ('xpn9pjscdnrmeun1lhmd048kqfnp5gqe','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.098928');
INSERT INTO "django_session" VALUES ('i6rxjrdg0o9hd1cv1x3lg1ikxxtiylmv','eyJtZXNhIjoxfQ:1qH9rK:75Gv8o6ymrWN3HE2kas1ixKiLptIA9Sr3rGAy5_kCg4','2023-07-19 21:16:22.350279');
INSERT INTO "django_session" VALUES ('pnk0w2r0vyh8ujwjd1zsr4oyp9ld4k8z','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.443601');
INSERT INTO "django_session" VALUES ('r8fravoyvf7502rlbwu2qdtuk3hj8b14','eyJtZXNhIjoxfQ:1qH9rM:QeRzoESce7OAJrIdS9mWr4pJjY4aou9_t2eL2yqxOtw','2023-07-19 21:16:24.437670');
INSERT INTO "django_session" VALUES ('p2vw3m91ona7ml6lfwpn5v9k2aoz2ppf','eyJtZXNhIjo4OTc0MTg4ODkyMTAwMjYwOTU3fQ:1qH9rS:NQelgzNBYhg_dCJAFnjXWbbZrqxb-El1D1897aKp14Q','2023-07-19 21:16:30.686716');
INSERT INTO "django_session" VALUES ('wvhf5smjl3mszhk5pkarxvlatwjhn66w','eyJtZXNhIjo2OTEzMzMyMTkzOTg1MjI5Mjg3fQ:1qH9rS:uUSthF_2bn91PeDkWEIjmoHqdA_8GBhNNTftBhzhdac','2023-07-19 21:16:30.752468');
INSERT INTO "django_session" VALUES ('qt3jv897v28rvj50qwpmztp1zdbe3szn','eyJtZXNhIjoxfQ:1qH9rU:ViL1eVESwrN8VZbVwI4tqEpIRPcWwdZHyoASnT05ock','2023-07-19 21:16:32.051541');
INSERT INTO "django_session" VALUES ('sd7zla4z7iehaisbh33jaewt9vtq09vr','eyJtZXNhIjoxfQ:1qH9rW:NgMocKqIlR4IpK9JdMx_4a0jpqicMMxv0w9Nyl_6PmI','2023-07-19 21:16:34.442641');
INSERT INTO "django_session" VALUES ('kknv3r5ybnqh26uxkogjpmdggs4m8gdm','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.362111');
INSERT INTO "django_session" VALUES ('kdc3z4yt7apqd5710z4ro8i3dc9khns3','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.380338');
INSERT INTO "django_session" VALUES ('vzw4h0hvf396w3lflr8jd506u9qpyo7w','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.400724');
INSERT INTO "django_session" VALUES ('fh0ucyhnv3ms1l1g2dfa7d8oi4lcutud','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.414511');
INSERT INTO "django_session" VALUES ('9d3p3wnnoezg32hehmxbumv7fdk41ptx','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.427300');
INSERT INTO "django_session" VALUES ('l3wponcq90aczdmgb9b3l45pqmx8za5c','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.439853');
INSERT INTO "django_session" VALUES ('5f2omk4blgdrx3fc38sl6f59ma29efhb','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.449990');
INSERT INTO "django_session" VALUES ('ydkju1q82zy0gapiqll4n2yczpqu5lwp','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.458473');
INSERT INTO "django_session" VALUES ('i0vb1fcjafcv4ptuddiolh93ph8cr7ww','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.466818');
INSERT INTO "django_session" VALUES ('8f92g8h3kke9440izhhbebkuh5dxlh4l','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.474595');
INSERT INTO "django_session" VALUES ('lc0glj3sof35h5r7w0m3ulyg6smmooej','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.482543');
INSERT INTO "django_session" VALUES ('bagqnvmilq4atk3fh5z9egcq18br5755','eyJtZXNhIjoxfQ:1qH9rX:rD14YAFxzUuydNloYFXkVVZ2Q-VN-WSlbYQfRJLJTZo','2023-07-19 21:16:35.491508');
INSERT INTO "django_session" VALUES ('ld1vde2cyn9ijmw14owula131ic872bi','eyJtZXNhIjoxfQ:1qH9zV:Z_78LxvZH8O1l1PInWSt5QznAfZ--l_hXxMyTdYwERc','2023-07-19 21:24:49.294419');
INSERT INTO "django_session" VALUES ('cwdz71ua5k90snadpnqelizllxage25n','eyJtZXNhIjoxfQ:1qH9zh:Vdc1uwaFOHdLIbOtBDWAQgK0WnvmQsgYMv_qKwkelAk','2023-07-19 21:25:01.832995');
INSERT INTO "django_session" VALUES ('ab6ltj2318pmebhwdebkwk39a5p2p8jn','eyJtZXNhIjoxfQ:1qHA0R:ZYATItb4v-yssYNlPsS-RSpzGbF64FjTiSfIyDomTUA','2023-07-19 21:25:47.835584');
INSERT INTO "django_session" VALUES ('r1qkz6spnx6mo26ceqko1ow2zfhx260u','eyJtZXNhIjoxfQ:1qHA0N:DX1_A_LPnc0EyhGnsnWL4GR_P7UhC7LgCKOZa78e5WU','2023-07-19 21:25:43.191510');
INSERT INTO "django_session" VALUES ('lnfjuukqigakhlcmths7iwt9sjktks5d','eyJtZXNhIjoxfQ:1qHA0X:0dGW2CXrz2VWFvxmW5d-XSUaXJ-R4hMpDGqFsoeoAl0','2023-07-19 21:25:53.598897');
INSERT INTO "django_session" VALUES ('z19ptntgx5m20158jgnzr3ybeo4t43xb','eyJtZXNhIjoxfQ:1qHA0Q:-aAyDEa8eb_hcqRJlMrjens0n0dCa2R5VwBX_E4dWxo','2023-07-19 21:25:46.099616');
INSERT INTO "django_session" VALUES ('urffi5ykbtiv00af08ni9c5i8gxvg4pz','eyJtZXNhIjoxfQ:1qHA0P:cyNmLqtPTbpzO14ZnF8wol8wCPYZFoWskz3meXQfrz8','2023-07-19 21:25:45.611027');
INSERT INTO "django_session" VALUES ('f62d8cokd7emkdj4tfjd6eq40yshnn9e','eyJtZXNhIjoxfQ:1qHA0Q:-aAyDEa8eb_hcqRJlMrjens0n0dCa2R5VwBX_E4dWxo','2023-07-19 21:25:46.560920');
INSERT INTO "django_session" VALUES ('3twyinm402oxjw7aj23nreunvdku95lz','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.344135');
INSERT INTO "django_session" VALUES ('4nl84d5cuofnj0ql1mfic7p153hjb9ht','eyJtZXNhIjoxfQ:1qHA0V:ef-OlqaAlyZQzMRXNIw1_bOJ7jcR9obfIJZjRB8xihI','2023-07-19 21:25:51.137820');
INSERT INTO "django_session" VALUES ('iz6u4m92qfqykms1a0rfeyr8nyxxyssv','eyJtZXNhIjoxfQ:1qHA0U:Z1-1v4iZl52wGfdRnfkURF-FEMVQ39WBHN_uQure7rE','2023-07-19 21:25:50.611977');
INSERT INTO "django_session" VALUES ('5k3lxj218ck8rmiui0who1hwl4qxbanj','eyJtZXNhIjoxfQ:1qHA0O:oV6LsmR3Qfuqop56W9bbS3AEMYZtXdZjQ8KLFSKSV4g','2023-07-19 21:25:44.691289');
INSERT INTO "django_session" VALUES ('byyezxakj9tr315n0fhpgy6gnk406zgz','eyJtZXNhIjoxfQ:1qHA0T:7TBX7Y42H7Se7Lxqgb2vyX8Eu9naoh17WJohk1-tAP0','2023-07-19 21:25:49.789955');
INSERT INTO "django_session" VALUES ('dcxyxmh57s5w6jrmaeurnx90lfs9mbiv','eyJtZXNhIjoxfQ:1qHA0x:9HyVDBXbERC6p3gDq4aDNV_-asyKQCpntE8sKSFIq6E','2023-07-19 21:26:19.550402');
INSERT INTO "django_session" VALUES ('ozr0zmscxcvt0m69aev4em9v9farqy25','eyJtZXNhIjoxfQ:1qHA0y:FlUbnHHhSrrmp3LVSkwEwwI5YXE5KjxnOaRsoGDmclo','2023-07-19 21:26:20.319264');
INSERT INTO "django_session" VALUES ('qlc5n20sji0xowwiancny79ua24rm4ra','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.287655');
INSERT INTO "django_session" VALUES ('0jzq7ozsy6ljgyf7ijz698fct4i70843','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.327129');
INSERT INTO "django_session" VALUES ('8pd29qo1yief9wpdopk278o77rcs9bug','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.353565');
INSERT INTO "django_session" VALUES ('07l27jfx2va7mit3j1g97zfsn1ywjs4p','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.372957');
INSERT INTO "django_session" VALUES ('bf1ae5tzh0auobnchks4xl7qtpsqdpmd','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.388164');
INSERT INTO "django_session" VALUES ('wzmb0sns3nsyhtf0ptd8dgy3y0tmansp','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.401516');
INSERT INTO "django_session" VALUES ('r1oa8do632izv7400kcoul263rcvfvbw','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.414514');
INSERT INTO "django_session" VALUES ('yxh3092rujxoaj2afn49p5j0anv50y6v','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.429100');
INSERT INTO "django_session" VALUES ('vve7gzrzgcw8yt1x7hyhrimtzfpkcpos','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.441792');
INSERT INTO "django_session" VALUES ('b6kieuder0l1bqx9wivm9pwreqi12ovs','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.454879');
INSERT INTO "django_session" VALUES ('1af130ts05shk6tz4hxdm2f6bnhhrd0z','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.468398');
INSERT INTO "django_session" VALUES ('bbqm22tsx02vxq09zdeothh8urjqdew3','eyJtZXNhIjoxfQ:1qHA0z:MBFdOySaZnZzgIG0TXo5fFJlE9j8keITzw8-_U1POaU','2023-07-19 21:26:21.481820');
INSERT INTO "django_session" VALUES ('ynb86220uc9kc78m6e5941jinlueia27','.eJxVjDsOgzAQBe-ydWSBP4tNmT5nQGvvOpCPkTBUUe6eINHQvpk3H3hLJejtBQba1nHYqizDxNBDC6ctUnpK2QE_qNxnleayLlNUu6IOWtVtZnldD_cUGKmOe1ajdkwd-QaT99kFtJk8BzHaJEQdnUVuWTKSCW1OITSE8n_lrhOH8P0BkQI6FQ:1qHApa:EGlEnn5kzw0xYFnZeeLkZJpIRJ7H4FP_tlOkhkLf294','2023-07-19 22:18:38.134357');
INSERT INTO "restaurant_api" VALUES (1,'http://restaurant:8080/api/v1/');
INSERT INTO "restaurant_item" VALUES (1,'Cola','coca-cola.jpg',2.5,0,'bebida',5);
INSERT INTO "restaurant_item" VALUES (2,'Agua','534504_4.jpg',1.5,0,'bebida',5);
INSERT INTO "restaurant_item" VALUES (3,'Fanta','29191_3_fanta-refrigerante-com-gas-laranja-33cl.jpg',2.5,0,'bebida',5);
INSERT INTO "restaurant_item" VALUES (4,'Pizza Margarita','pizzas-imagem-generica-1024x684.jpg',10,7,'comida',5);
INSERT INTO "restaurant_item" VALUES (5,'Pizza Cogumelos','melhores-receitas-de-pizza.jpg',10,6,'comida',5);
INSERT INTO "restaurant_item" VALUES (6,'Pizza Peperoni','PizzaCalabresa.jpg',11,6,'comida',5);
INSERT INTO "restaurant_item" VALUES (7,'Pica-pau','pica-pau-portuguesa.jpg',8,15,'comida',4);
INSERT INTO "restaurant_restaurante" VALUES (1,'Simulado','FastFood','O melhor restaurante do mundo é o nosso','restaurantes/especie-restaurante-vegetariano-1-1024x819.jpg','destaque',1,3.5,5);
INSERT INTO "restaurant_restaurante" VALUES (2,'MacDonaldo','FastFood','MacDonaldo o melhor restaurante que já existiu','restaurantes/rest-default.jpg','desconto',NULL,3.9,5);
INSERT INTO "restaurant_restaurante" VALUES (3,'Divino','Sushi','O melhor sushi que poderá alguma vez experimentar','restaurantes/photo0jpg.jpg','oferta',NULL,4.3,7);
INSERT INTO "restaurant_restaurante" VALUES (4,'Petiscos','Carne','A melhor carne da Amadora e arredores experimenta a melhro carne argentina da atualidade.','restaurantes/carne-patinho-qual-o-segredo-do-patinho.jpg','destaque',NULL,3.9,8);
INSERT INTO "restaurant_restaurante" VALUES (5,'GoldenPizza','Pizza','A melhor pizza do planeta experimenta as nossas especialidades da casa, irão amar.','restaurantes/44772_748DFD89F9513B65.jpg','destaque',NULL,4.1,8);
INSERT INTO "restaurant_restaurante" VALUES (6,'FinePasta','Massa','Charmoso restaurante especializado em massas localizado no coração da cidade. Faz já o teu pedido.','restaurantes/dedd244f2e7c66775801eec1f147251c745ec56c-2000x1334.jpg','destaque',NULL,3.2,15);
INSERT INTO "user_profile" VALUES (1,'admin','Rua da Papoila nº1, 1º Esquerdo','234234234',1,'Ivo Nunes','user/IMG_9133.jpg');
INSERT INTO "user_profile" VALUES (2,'delivery','Rua Dr. Gomes, 21 - 3esq','111222333',7,'Alberto','user/i722748.webp');
INSERT INTO "user_profile" VALUES (3,'utilizador',NULL,'111111111',6,'Pedro Penim','user/user-default.png');
INSERT INTO "restaurant_itempedido" VALUES (4,6,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (5,3,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (6,7,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (9,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (10,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (11,7,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (12,4,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (13,7,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (14,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (15,3,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (16,5,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (17,4,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (18,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (19,3,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (20,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (21,3,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (22,5,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (23,4,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (24,2,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (25,6,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (26,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (27,3,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (28,5,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (29,2,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (30,1,8,1);
INSERT INTO "restaurant_itempedido" VALUES (31,3,8,1);
INSERT INTO "restaurant_itempedido" VALUES (32,2,8,1);
INSERT INTO "restaurant_itempedido" VALUES (33,7,8,1);
INSERT INTO "restaurant_itempedido" VALUES (34,1,NULL,1);
INSERT INTO "restaurant_itempedido" VALUES (35,4,13,1);
INSERT INTO "restaurant_itempedido" VALUES (36,6,13,1);
INSERT INTO "restaurant_itempedido" VALUES (37,3,13,1);
INSERT INTO "restaurant_itempedido" VALUES (38,3,14,1);
INSERT INTO "restaurant_itempedido" VALUES (39,5,14,1);
INSERT INTO "restaurant_itempedido" VALUES (40,6,14,1);
INSERT INTO "restaurant_itempedido" VALUES (41,1,14,1);
INSERT INTO "restaurant_itempedido" VALUES (42,7,14,1);
INSERT INTO "restaurant_itempedido" VALUES (43,3,15,2);
INSERT INTO "restaurant_itempedido" VALUES (44,2,15,2);
INSERT INTO "restaurant_itempedido" VALUES (45,1,15,2);
INSERT INTO "restaurant_itempedido" VALUES (46,1,16,1);
INSERT INTO "restaurant_itempedido" VALUES (47,2,16,1);
INSERT INTO "restaurant_itempedido" VALUES (48,3,16,1);
INSERT INTO "restaurant_itempedido" VALUES (49,7,17,1);
INSERT INTO "restaurant_itempedido" VALUES (50,7,18,3);
INSERT INTO "restaurant_itempedido" VALUES (51,7,19,1);
INSERT INTO "restaurant_itempedido" VALUES (52,6,19,1);
INSERT INTO "restaurant_itempedido" VALUES (53,4,19,1);
INSERT INTO "restaurant_pedido" VALUES (8,'2023-06-24 22:20:52.588708',NULL,5,1,'1687645580.369086',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (13,'2023-06-27 20:33:37.344389',NULL,7,1,'1687899191.401886',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (14,'2023-06-27 20:56:00.907437',NULL,7,0,'1687899383.540837',0,1,3,NULL);
INSERT INTO "restaurant_pedido" VALUES (15,'2023-06-27 21:23:19.246943',NULL,9,1,'1687901131.269567',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (16,'2023-07-04 19:59:08.144437',NULL,4,1,'1688500870.092529',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (17,'2023-07-04 20:07:45.177932',NULL,4,1,'1688501327.712265',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (18,'2023-07-04 20:11:35.847229',NULL,4,1,'1688501571.597088',1,1,1,2);
INSERT INTO "restaurant_pedido" VALUES (19,'2023-07-05 22:18:28.529570',NULL,4,0,'0',0,0,1,NULL);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" (
	"group_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" (
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" (
	"permission_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" (
	"user_id",
	"group_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_groups_group_id_97559544" ON "auth_user_groups" (
	"group_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" (
	"user_id",
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" (
	"permission_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_admin_log_user_id_c564eba6" ON "django_admin_log" (
	"user_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" (
	"app_label",
	"model"
);
CREATE UNIQUE INDEX IF NOT EXISTS "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" (
	"content_type_id",
	"codename"
);
CREATE INDEX IF NOT EXISTS "auth_permission_content_type_id_2f476e4b" ON "auth_permission" (
	"content_type_id"
);
CREATE INDEX IF NOT EXISTS "django_session_expire_date_a5c62663" ON "django_session" (
	"expire_date"
);
CREATE INDEX IF NOT EXISTS "restaurant_item_restaurante_id_d126079a" ON "restaurant_item" (
	"restaurante_id"
);
CREATE UNIQUE INDEX IF NOT EXISTS "restaurant_pedido_restaurante_pedido_id_restaurante_id_55fc5940_uniq" ON "restaurant_pedido_restaurante" (
	"pedido_id",
	"restaurante_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_pedido_restaurante_pedido_id_de878d0d" ON "restaurant_pedido_restaurante" (
	"pedido_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_pedido_restaurante_restaurante_id_066de6ee" ON "restaurant_pedido_restaurante" (
	"restaurante_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_itempedido_item_id_ef89a1f9" ON "restaurant_itempedido" (
	"item_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_itempedido_pedido_id_fa8ef95f" ON "restaurant_itempedido" (
	"pedido_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_pedido_cliente_id_aa6a24d7" ON "restaurant_pedido" (
	"cliente_id"
);
CREATE INDEX IF NOT EXISTS "restaurant_pedido_entregador_id_924a94ac" ON "restaurant_pedido" (
	"entregador_id"
);
COMMIT;
