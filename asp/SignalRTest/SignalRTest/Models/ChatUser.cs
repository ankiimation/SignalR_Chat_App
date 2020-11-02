using System;
using System.Collections.Generic;

namespace SignalRTest.Models
{
    public partial class ChatUser
    {
        public string Email { get; set; }
        public bool IsConnected { get; set; }
        public bool HasPartner { get; set; }
    }
}
