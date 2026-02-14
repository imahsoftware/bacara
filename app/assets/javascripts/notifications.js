// app/javascript/channels/notifications.js
document.addEventListener("DOMContentLoaded", function () {

    if (window.CURRENT_USER_ID) {
        console.log("🔥 notifications.js cargado");

        // ===== FUNCIÓN PARA MOSTRAR NOTIFICACIÓN =====
        function mostrarNotificacion(data) {
            const mensaje = data.mensaje || "Nueva notificación";
            const observacion = data.observacion || "";
            const notifId = data.id || Date.now();

            let container = document.getElementById("notifications-container");
            if (!container) {
                container = document.createElement("div");
                container.id = "notifications-container";
                container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                display: flex;
                flex-direction: column;
                gap: 10px;
                max-width: 360px;
            `;
                document.body.appendChild(container);
            }

            const div = document.createElement("div");
            div.id = `notif-${notifId}`;
            div.dataset.notificationId = notifId;
            div.style.cssText = `
            background: #fff;
            color: #333;
            padding: 16px 20px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,.15);
            font-family: system-ui, -apple-system, sans-serif;
            position: relative;
            animation: slideIn 0.4s ease-out;
            border-left: 4px solid #007bff;
        `;

            div.innerHTML = `
            <button onclick="cerrarNotificacion(${notifId})"
                    style="
                        position: absolute;
                        top: 12px;
                        right: 12px;
                        background: transparent;
                        border: none;
                        color: #999;
                        font-size: 24px;
                        cursor: pointer;
                        padding: 0;
                        width: 28px;
                        height: 28px;
                        line-height: 28px;
                        text-align: center;
                        transition: all 0.2s;
                        border-radius: 4px;
                    "
                    onmouseover="this.style.background='#f0f0f0'; this.style.color='#333';"
                    onmouseout="this.style.background='transparent'; this.style.color='#999';">×</button>

            <div style="display: flex; align-items: flex-start; gap: 12px; margin-bottom: 8px;">
                <img src="https://cdn-icons-png.flaticon.com/512/5683/5683325.png"
                     alt="Logo"
                     style="width: 48px; height: 48px; border-radius: 8px; object-fit: cover;">

                <div style="flex: 1;">
                    <div style="font-size: 14px; font-weight: 600; color: #007bff; margin-bottom: 4px;">
                        Notificación
                    </div>
                    <div style="font-size: 15px; font-weight: 500; color: #333; line-height: 1.4;">
                        ${mensaje}
                    </div>
                </div>
            </div>

            ${observacion ? `
                <div style="
                    margin-top: 8px;
                    padding-top: 12px;
                    border-top: 1px solid #e9ecef;
                    font-size: 14px;
                    color: #666;
                    line-height: 1.5;
                ">
                    ${observacion}
                </div>
            ` : ""}
        `;

            const style = document.createElement("style");
            style.textContent = `
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(100px) scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: translateX(0) scale(1);
                }
            }
        `;
            if (!document.getElementById("notification-animations")) {
                style.id = "notification-animations";
                document.head.appendChild(style);
            }

            container.appendChild(div);

            // Auto-cerrar después de 10 segundos
            setTimeout(() => cerrarNotificacion(notifId), 40000);
        }

        // ===== CERRAR Y MARCAR COMO LEÍDA =====
        window.cerrarNotificacion = function (notifId) {
            const div = document.querySelector(`[data-notification-id="${notifId}"]`);
            if (div) {
                // Animación de salida
                div.style.animation = 'slideOut 0.3s ease-in';

                setTimeout(() => {
                    div.remove();
                }, 300);

                // Marcar como leída en el servidor
                fetch(`/notificacionesplataformas/${notifId}/marcar_como_leida`, {
                    method: 'PATCH',
                    headers: {
                        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
                        'Content-Type': 'application/json'
                    }
                });
            }
        };

        // Agregar animación de salida
        const existingStyle = document.getElementById("notification-animations");
        if (existingStyle) {
            existingStyle.textContent += `
            @keyframes slideOut {
                from {
                    opacity: 1;
                    transform: translateX(0) scale(1);
                }
                to {
                    opacity: 0;
                    transform: translateX(100px) scale(0.9);
                }
            }
        `;
        }

        // ===== CARGAR NOTIFICACIONES NO LEÍDAS AL INICIAR =====
        fetch('/notificacionesplataformas')
            .then(res => res.json())
            .then(notificaciones => {
                console.log(`📬 ${notificaciones.length} notificaciones pendientes`);
                notificaciones.forEach(notif => mostrarNotificacion(notif));
            })
            .catch(err => console.error('Error cargando notificaciones:', err));

        // ===== SUSCRIPCIÓN A WEBSOCKET =====
        App.notifications = App.cable.subscriptions.create(
            {
                channel: "NotificationsChannel",
                user_id: window.CURRENT_USER_ID
            },
            {
                connected() {
                    console.log("✅ Conectado a NotificationsChannel");
                    console.log("🔑 Usuario conectado:", window.CURRENT_USER_ID);
                },

                disconnected() {
                    console.log("❌ Desconectado");
                },

                received(data) {
                    console.log("🚨 NOTIFICACIÓN EN TIEMPO REAL", data);
                    mostrarNotificacion(data);
                }
            }
        );
    } else {
        console.log("⚠️ No hay usuario logueado, ActionCable no se iniciará");
    }
});