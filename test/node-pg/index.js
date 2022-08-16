const dns = require('dns');

dns.lookup('db', (err, ip) => {
    if (err) throw err;
    console.log('db is at', ip);
});
