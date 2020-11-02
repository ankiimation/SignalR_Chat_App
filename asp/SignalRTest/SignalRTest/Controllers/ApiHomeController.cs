using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SignalRTest.Models;

namespace SignalRTest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ApiHomeController : ControllerBase
    {
        [HttpGet]
        public IActionResult getOnlineUser()
        {
            var users = (new SIGNALR_CHAT_TESTContext()).ChatUser.Where(u=>u.IsConnected && !u.HasPartner && u.ConnectionId!=null).ToList();
            return Ok(users);
        }
    }
}
