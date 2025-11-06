CREATE TABLE Recompensas (
    id_recompensas INT PRIMARY KEY AUTO_INCREMENT,
    nombre_recompensas VARCHAR(255) NOT NULL,
    valor_tokens INT NOT NULL CHECK (valor_tokens >= 0),
    descripcion VARCHAR(500),
    periodo_vencimiento DATE,
    canjeado BOOLEAN DEFAULT FALSE,
    acceso_premium BOOLEAN DEFAULT FALSE
);

CREATE TABLE Usuario_Recompensa (
    id_usuario INT,
    id_recompensas INT,
    fecha_canjeo DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_recompensas),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_recompensas) REFERENCES Recompensas(id_recompensas) ON DELETE CASCADE
);

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    tokens INT DEFAULT 0 CHECK (tokens >= 0),
    premium BOOLEAN DEFAULT FALSE
);
