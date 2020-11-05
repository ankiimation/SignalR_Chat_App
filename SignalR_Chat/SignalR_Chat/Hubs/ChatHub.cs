using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using SignalR_Chat.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace SignalR_Chat.Hubs
{
    [Authorize]
    public class ChatHub : Hub
    {
        private static HashSet<string> ids = new HashSet<string>();
        private static HashSet<string> rooms = new HashSet<string>();
        public async Task SendMessage(string message)
        {
            if (getPartner(Context.ConnectionId) != null)
            {
                var messageModel = (new ChatMessageModel(Context.ConnectionId,message,DateTime.Now.ToString())).toJson();
                var myPartner = rooms.FirstOrDefault(r => r.Contains(Context.ConnectionId)).Replace(Context.ConnectionId, "");
                await Clients.Clients(Context.ConnectionId, myPartner).SendAsync("ReceiveMessage", messageModel);
            }
            else
            {
                var messageModel = (new ChatMessageModel("admin", "No Partner", DateTime.Now.ToString())).toJson();
                await Clients.Clients(Context.ConnectionId).SendAsync("ReceiveMessage", messageModel);
            }
        }

        public void AddRandomRoom(string member)
        {
           
            List<string> freeIds = ids.Where(id => rooms.FirstOrDefault(r => r.Contains(id)) == null && id != member).ToList();
         
            
            if (freeIds != null && freeIds.Count > 0)
            {
                string myPartner = freeIds.ElementAt(0);
                if (freeIds.Count > 1)
                    myPartner = freeIds.ElementAt((new Random()).Next(freeIds.Count));
                AddToRoom(member, myPartner);
                var messageModel = (new ChatMessageModel(member, "Connected", DateTime.Now.ToString())).toJson();
                Clients.Clients(member, myPartner).SendAsync("ReceiveMessage", messageModel);
            }
        }

        private string getPartner(string member)
        {
            var result = rooms.FirstOrDefault(r => r.Contains(member));
            if (result != null)
            {
                return result.Replace(member, "");
            }
            else
            {
                return null;
            }
        }
        public void AddToRoom(string member1, string member2)
        {
            rooms.Add(member1 + member2);
            Clients.Clients(member1, member2).SendAsync("AddToRoom", member1, member2);
        }
        public void RemoveFromRoom(string member1Or2)
        {
            var myPartner = getPartner(member1Or2);
            rooms.RemoveWhere(r => r.Contains(member1Or2));
            Clients.Clients(member1Or2, myPartner).SendAsync("LeaveFromRoom", member1Or2, myPartner);
            AddRandomRoom(myPartner);
        }
        public override Task OnConnectedAsync()
        {

            ids.Add(Context.ConnectionId);

            AddRandomRoom(Context.ConnectionId);


            return base.OnConnectedAsync();
        }
        public override Task OnDisconnectedAsync(Exception exception)
        {
            var myPartner = getPartner(Context.ConnectionId);
            ids.Remove(Context.ConnectionId);
            RemoveFromRoom(Context.ConnectionId);
            return base.OnDisconnectedAsync(exception);
        }


    }
}
