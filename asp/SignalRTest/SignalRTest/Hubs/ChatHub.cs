using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;
using SignalRTest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalRTest.Hubs
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class ChatHub : Hub
    {
        public SIGNALR_CHAT_TESTContext context = new SIGNALR_CHAT_TESTContext();
        public void SendMessage(string partnerEmail, string message)
        {
            String myEmail = Context.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
            var partner = context.ChatUser.FirstOrDefault(u => u.Email.Equals(partnerEmail));
            if (partner != null && partner.IsConnected && partner.HasPartner)
            {
                Clients.Groups(partnerEmail, myEmail).SendAsync("ReceiveMessage", "ReceiveMessage", myEmail, message);
            }

        }

        public void ConnectWithPartner(String partnerEmail)
        {
            String myEmail = Context.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
            var me = context.ChatUser.FirstOrDefault(u => u.Email.Equals(myEmail));
            var partner = context.ChatUser.FirstOrDefault(u => u.Email.Equals(partnerEmail));
            if (partner != null && me != null)
            {
                me.HasPartner = true;
                partner.HasPartner = true;
                context.ChatUser.Update(me);
                context.ChatUser.Update(partner);
                context.SaveChanges();
                Clients.Groups(me.Email, partner.Email).SendAsync("ReceiveMessage", "ConnectWithPartner", me.Email);
            }
        }
        public void DisconnectWithPartner(String partnerEmail)
        {
            String myEmail = Context.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
            var me = context.ChatUser.FirstOrDefault(u => u.Email.Equals(myEmail));
            var partner = context.ChatUser.FirstOrDefault(u => u.Email.Equals(partnerEmail));
            if (partner != null && me != null)
            {
                me.HasPartner = false;
                partner.HasPartner = false;
                context.ChatUser.Update(me);
                context.ChatUser.Update(partner);
                context.SaveChanges();
                Clients.Groups(me.Email, partner.Email).SendAsync("ReceiveMessage", "DisconnectWithPartner", me.Email);
            }
        }

        public void disconnect()
        {
            String identityEmail = Context.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
            var user = context.ChatUser.FirstOrDefault(u => u.Email.Equals(identityEmail));
            if (user != null)
            {
                user.IsConnected = false;
                user.HasPartner = false;
                context.Update(user);
                context.SaveChanges();
                Groups.RemoveFromGroupAsync(Context.ConnectionId, user.Email);

            }
        }


        public override Task OnConnectedAsync()
        {
            String identityEmail = Context.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
            //db
            var user = context.ChatUser.FirstOrDefault(u => u.Email.Equals(identityEmail));
            if (user == null)
            {
                user = new ChatUser();
                user.Email = identityEmail;
                user.IsConnected = true;
                user.HasPartner = false;
                context.ChatUser.Add(user);

            }
            else
            {
                user.IsConnected = true;
                user.HasPartner = false;
                context.ChatUser.Update(user);

            }
            context.SaveChanges();

            //chat
            Groups.AddToGroupAsync(Context.ConnectionId, user.Email);
            return base.OnConnectedAsync();
        }

    }
}
