using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_Chat.Models
{
    public class ChatMessageModel
    {
        public string from;
        public string message;
        public string dateTime;

        public ChatMessageModel(string from,string message, string dateTime)
        {
            this.from = from;
            this.message = message;
            this.dateTime = dateTime;
        }
        public string toJson()
        {
            return JsonConvert.SerializeObject(this);
        }
        public ChatMessageModel fromJson(String json)
        {
            return JsonConvert.DeserializeObject<ChatMessageModel>(json);
        }
    }
}
