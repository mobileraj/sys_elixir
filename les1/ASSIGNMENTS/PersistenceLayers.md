- *Patient Data*:
	- Relational DB:
		- Lots of reads. First-time creates. Updates to tables with data.
		- Patient table can be made with some base information, such as the phn and patient name.
		- Foreign keys in other tables for additional data such as notes and sessions.
		- Allows for joins on additional information as needed. Expresses the relationship between other tables.
	- Other:
		- Key-value JSON store:
			- Could represent data; however, JSON does not enforce consistent format.
			- Main disadvantage: doesn't allow for joins and complex queries.
- *Session Data*:
	- *Session metadata (e.g. sessionId, duration, start, end, participants, etc)*:
		- Relational DB:
			- High number of reads. One create per session. Low (if any updates or deletes).
			- makes it easy to join with patients; fits within relational model. 
		- Other:
			- Key-value JSON store (again):
				- Same problems as with patient data.
	- *Session Recordings*:
		- Storage Solution (such as cloud storage):
			- A lengthy Session could take well over a gigabyte in storage.
			- It might need to be accessed by users, but not very frequently. When accessed, won't need partial access. Access will get whole thing.
				- Never updated. 
				- Delete after a certain amount of time of growing mold?
			- Thus, needs the ability to efficiently store lots of data that won't likely have much traffic
			- Just needs to be accessible by sessionId (with correct authorization). Don't need complex querying or joins.
		- Other:
			- Relational DB 
				- Won't need the complex querying or joins. Probably more efficient to store in a simple manner.
- *Auth Info*:
	- Key value JSON store:
		- Data stored: email, uid, hashed_password, and any other information to indicate the client-server active session (JWT?)
		- Functionality required:
			- login with email and password
			- logout with nothing
			- Check to see if authorized
				- with token or flag possibly.
		- Frequent read and write of client-server active session (not video session). User data frequent read but not write (as password and email do not change frequently)
		- No need to join.
	- Other: 
		- Relational DB:
			- May work; however, possibly an overkill?