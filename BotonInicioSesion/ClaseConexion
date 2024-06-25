using MySql.Data.MySqlClient;
using System.Windows;
using System;

public class MariaDBConnection
{
    private MySqlConnection connection;
    private string server;
    private string database;
    private string uid;
    private string password;
    private int port;

    // Constructor
    public MariaDBConnection(string server, string database, string uid, string password, int port)
    {
        this.server = server;
        this.database = database;
        this.uid = uid;
        this.password = password;
        this.port = port;

        Initialize();
    }

    // Inicializa la conexión
    private void Initialize()
    {
        string connectionString;
        connectionString = $"SERVER={server};PORT={port};DATABASE={database};UID={uid};PASSWORD={password};";

        connection = new MySqlConnection(connectionString);
    }

    // Abre la conexión a la base de datos
    public bool OpenConnection()
    {
        try
        {
            connection.Open();
            return true;
        }
        catch (MySqlException ex)
        {
            // Gestión de errores de conexión
            switch (ex.Number)
            {
                case 0:
                    MessageBox.Show("No se puede conectar al servidor de la base de datos.");
                    break;
                case 1045:
                    MessageBox.Show("Credenciales inválidas.");
                    break;
                default:
                    MessageBox.Show(" Error de conexión: " + ex.Message);
                    break;
            }
            return false;
        }
    }

    // Cierra la conexión a la base de datos
    public bool CloseConnection()
    {
        try
        {
            connection.Close();
            return true;
        }
        catch (MySqlException ex)
        {
            MessageBox.Show("Wasaaaaaa1");
            return false;
        }
    }

    // Ejecuta una consulta SQL
    public MySqlDataReader ExecuteQuery(string query)
    {
        MySqlCommand cmd = new MySqlCommand(query, connection);
        MySqlDataReader dataReader = cmd.ExecuteReader();
        return dataReader;
    }

    // Ejecuta una consulta SQL que no devuelve datos (INSERT, UPDATE, DELETE)
    public int ExecuteNonQuery(string query)
    {
        MySqlCommand cmd = new MySqlCommand(query, connection);
        int result = cmd.ExecuteNonQuery();
        return result;
    }

    // Ejecuta una consulta SQL y devuelve el resultado como un objeto escalar
    public object ExecuteScalar(string query)
    {
        MySqlCommand cmd = new MySqlCommand(query, connection);
        object result = cmd.ExecuteScalar();
        return result;
    }
}
