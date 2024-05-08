///数据表定义
class CreateTableSqls{
  //关系表语句
  static final String createTableSql_tomatoFolder = '''
    CREATE TABLE IF NOT EXISTS tomato_folder (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
    title VARCHAR(255),
    description varchar(255),
    device_id varchar(255),
    order_index TINYINT,
    update_time BIGINT(20) DEFAULT 0, 
    create_time BIGINT(20) DEFAULT 0
    );
    create index foloder_index on tomato_folder(update_time, create_time, order_index);
    ''';
  //用户表语句
  static final String createTableSql_tomatoMission = '''
    CREATE TABLE IF NOT EXISTS tomato_mission (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
    folder_id INTEGER,
    title VARCHAR(255),
    description varchar(255),
    device_id varchar(255),
    number_tomotoes_finished INTEGER,
    tomato_duration INTEGER,
    total_time_finised INTEGER,
    order_index TINYINT,
    update_time BIGINT(20) DEFAULT 0, 
    create_time BIGINT(20) DEFAULT 0
    );
    ''';
  Map<String,String> getAllTables(){
    Map<String,String> map = Map<String,String>();
    map['tomato_folder'] = createTableSql_tomatoFolder;
    map['tomato_mission'] = createTableSql_tomatoMission;

    return map;
  }
}