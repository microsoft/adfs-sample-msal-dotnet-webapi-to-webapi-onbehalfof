using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
namespace WebAPIOBO.Controllers
{
    public class WebAPIOBOController : ApiController
    {
        public IHttpActionResult Get()
        {
            return Ok("WebAPI via OBO");
        }
    }
}