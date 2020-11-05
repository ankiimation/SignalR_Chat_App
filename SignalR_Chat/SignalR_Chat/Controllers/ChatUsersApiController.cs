using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SignalR_Chat.Models;

namespace SignalR_Chat.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ChatUsersApiController : ControllerBase
    {
        signalrtestContext context;
        public ChatUsersApiController()
        {
            context = new signalrtestContext();
        }

        [HttpGet("{connectionId}")]

        public IActionResult getUserViaConnectionId(string connectionId)
        {
            var result = context.ChatUser.FirstOrDefault(u => u.ConnectionId.Equals(connectionId));
            if (result == null)
            {
                return NotFound();
            }
            else
            {
                return Ok(result);
            }
        }

        [HttpPost]
        public IActionResult addOrUpdate(ChatUser user)
        {
            if (getEmail().Equals(user.Email))
            {
                var current = context.ChatUser.FirstOrDefault(u => u.Email.Equals(user.Email));
                if (current != null)
                {
                    current.Avatar = user.Avatar;
                    current.Nickname = user.Nickname;
                    current.ConnectionId = user.ConnectionId;
                    context.ChatUser.Update(current);
                }
                else
                {
                    context.ChatUser.Add(user);
                }
                context.SaveChanges();
                return Ok();
            }
            else
            {
                return Forbid();
            }
        }
        [HttpPost("connectionid")]
        public IActionResult addOrUpdateConnectionId(ChatUser user)
        {
            if (getEmail().Equals(user.Email))
            {
                var current = context.ChatUser.FirstOrDefault(u => u.Email.Equals(user.Email));
                if (current != null)
                {
                    current.ConnectionId = user.ConnectionId;
                    context.ChatUser.Update(current);
                }
                else
                {
                    context.ChatUser.Add(user);
                }
                context.SaveChanges();
                return Ok();
            }
            else
            {
                return Forbid();
            }
        }
        private string getEmail()
        {
            return HttpContext.User.Claims.FirstOrDefault(c => c.Type.Equals("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress")).Value;
        }
    }
}
