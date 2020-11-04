using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace SignalR_Chat.Hubs
{
    public class ChatHub : Hub
    {
        public static HashSet<string> currentIds = new HashSet<string>();
        public static HashSet<HashSet<string>> rooms = new HashSet<HashSet<string>>();

        public async Task SendMessage(string to, string message)
        {
            await Clients.Clients(Context.ConnectionId,to).SendAsync("ReceiveMessage", Context.ConnectionId, message);
        }

        public void GetRoom(string connectionId)
        {
            var myRoom = rooms.FirstOrDefault(rom => rom.Contains(connectionId));
            if(myRoom!=null)
            Clients.Client(Context.ConnectionId).SendAsync("MyPartner", myRoom.FirstOrDefault(partner=>!partner.Equals(Context.ConnectionId)));
        }
        public void ConnectTo(string to)
        {
            if (currentIds.Contains(to))
            {
                HashSet<string> roomTemp = new HashSet<string> { Context.ConnectionId, to };
                rooms.Add(roomTemp);
                GetRoom(Context.ConnectionId);
                Clients.All.SendAsync("CurrentConnections", showFreeConnections());

            }
      

        }
        public void DisconnectFrom()
        {
            if (Context.ConnectionId != null)
            {
                var connectionId = Context.ConnectionId;
                HashSet<string> roomTemp = rooms.FirstOrDefault(rom => rom.Contains(connectionId));
                if (roomTemp != null)
                {
                    rooms.Remove(roomTemp);
                    var partnerId = roomTemp.FirstOrDefault(p => !p.Equals(connectionId));
                    if (partnerId != null)
                    {
                        Clients.Client(partnerId).SendAsync("PartnerConnection", "disconnected");
                    }
                    Clients.All.SendAsync("CurrentConnections", showFreeConnections());
                }

                
            }

        }

        public List<string> showFreeConnections()
        {
            var result = currentIds.Where(
                   id => rooms.Where(rom => rom.Contains(id)).ToList().Count == 0
                   ).ToList();
            return result;
        }
        public override Task OnConnectedAsync()
        {
            currentIds.Add(Context.ConnectionId);
            Clients.All.SendAsync("CurrentConnections", showFreeConnections());
            return base.OnConnectedAsync();

        }
        public override Task OnDisconnectedAsync(Exception exception)
        {
            DisconnectFrom();
            currentIds.Remove(Context.ConnectionId);
            Clients.All.SendAsync("CurrentConnections", showFreeConnections());
            return base.OnDisconnectedAsync(exception);
        }
    }
}
