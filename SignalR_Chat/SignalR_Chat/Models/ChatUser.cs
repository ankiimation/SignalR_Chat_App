using System;
using System.Collections.Generic;

namespace SignalR_Chat.Models
{
    public partial class ChatUser
    {
        public string Email { get; set; }
        public string Nickname { get; set; }
        public string Avatar { get; set; }
        public string ConnectionId { get; set; }
        public int? Gender { get; set; }
        public int? Age { get; set; }
    }
}
