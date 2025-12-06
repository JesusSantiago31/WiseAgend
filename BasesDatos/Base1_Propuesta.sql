-- ------------------------------------------------------------
-- Tabla: tienda_productos
-- Almacena los productos disponibles en la "tienda" de la app
-- (recompensas, plantillas, temas u otros ítems).
-- ------------------------------------------------------------
CREATE TABLE tienda_productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único del producto; se autoincrementa.

    nombre VARCHAR(100) NOT NULL,               -- Nombre legible del producto (requerido).
    tipo ENUM('recompensa', 'plantilla', 'tema', 'otro') NOT NULL,  -- Clasificación del producto; obliga a uno de los valores listados.
    costo INT DEFAULT 0 CHECK (costo >= 0),     -- Precio en monedas; por defecto 0 y no puede ser negativo.
    descripcion VARCHAR(255),                   -- Texto breve describiendo el producto (opcional).
    fecha_vencimiento DATE,                     -- Fecha límite hasta la que el producto está disponible (opcional).
    canjeado BOOLEAN DEFAULT FALSE,             -- Indica si el producto fue canjeado/agotado. FALSE = disponible.
    tipo_cuenta ENUM('free', 'premium_monedas', 'premium_pago') DEFAULT 'free' -- Determina a quién está dirigido.
    -- NOTA: en MySQL la lista termina sin problema aquí; recuerda el cierre de paréntesis y punto y coma abajo.
);

-- ------------------------------------------------------------
-- Tabla: usuarios_productos
-- Registra qué usuarios han comprado o canjeado qué productos.
-- Es la tabla intermedia que implementa la relación many-to-many.
-- ------------------------------------------------------------
CREATE TABLE usuarios_productos (
    id_usuario INT NOT NULL,                    -- Referencia al usuario que compra/canjea el producto (debe existir en usuarios).
    id_producto INT NOT NULL,                   -- Referencia al producto comprado (debe existir en tienda_productos).
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP, -- Marca cuándo se realizó la compra/canje (por defecto, ahora).
    
    PRIMARY KEY (id_usuario, id_producto),      -- Clave primaria compuesta evita duplicados: un usuario no puede tener dos filas idénticas.
    
    CONSTRAINT fk_usuarios_productos_usuario FOREIGN KEY (id_usuario) -- Nombre de la restricción FK hacia usuarios.
        REFERENCES usuarios(id_usuario)         -- Referencia a la tabla usuarios, columna id_usuario.
        ON DELETE CASCADE                       -- Si se borra el usuario, se borran sus compras en esta tabla.
        ON UPDATE CASCADE,                      -- Si se actualiza el id del usuario, se propaga aquí. (MySQL lo permite)
    
    CONSTRAINT fk_usuarios_productos_producto FOREIGN KEY (id_producto) -- Nombre de la restricción FK hacia tienda_productos.
        REFERENCES tienda_productos(id_producto) -- Referencia a la tabla tienda_productos, columna id_producto.
        ON DELETE CASCADE                       -- Si se borra el producto, se borran los registros asociados.
        ON UPDATE CASCADE                       -- Si se actualiza el id_producto, se propaga aquí.
);