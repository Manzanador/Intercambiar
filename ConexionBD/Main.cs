            InitializeComponent();
            string server = "192.168.2.53";
            string database = "hgugiato";
            string uid = "hgugiato";
            string password = "57233256";
            int port = 3306; // El puerto de MariaDB por defecto es 3306

            MariaDBConnection dbConnection = new MariaDBConnection(server, database, uid, password, port);

            // Abre la conexión
            if (dbConnection.OpenConnection())
            {
                Console.WriteLine("Conexión establecida.");

                // Ejemplo de consulta SELECT
                string query = "SELECT * FROM Clientes;";
                MySqlDataReader reader = dbConnection.ExecuteQuery(query);

                // Iterar sobre los resultados
                while (reader.Read())
                {
                    // Acceder a los datos, por ejemplo:
                    try { 
                    MessageBox.Show(reader["ClienteNombre"] + " -- " + reader["Direccion"]);
                    }catch
                    {
                        MessageBox.Show("Wasaaaa2");
                    }
                    }

                // Cierra la conexión
                dbConnection.CloseConnection();
            }
            else
            {
                MessageBox.Show("No se pudo establecer conexión.");
            }

            Console.ReadLine();
