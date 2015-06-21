/*
Copyright (c) 2000-2013 "independIT Integrative Technologies GmbH",
Authors: Ronald Jeninga, Dieter Stubler

schedulix Enterprise Job Scheduling System

independIT Integrative Technologies GmbH [http://www.independit.de]
mailto:contact@independit.de

This file is part of schedulix

schedulix is free software:
you can redistribute it and/or modify it under the terms of the
GNU Affero General Public License as published by the
Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/


package de.independit.scheduler.server.parser.filter;

import java.io.*;
import java.util.*;
import java.lang.*;

import de.independit.scheduler.server.*;
import de.independit.scheduler.server.repository.*;
import de.independit.scheduler.server.exception.*;

public class MasterIdFilter extends Filter
{
	HashSet mids;

	public MasterIdFilter(SystemEnvironment sysEnv, Vector ids)
	{
		super();
		mids = new HashSet();
		for(int i = 0; i < ids.size(); i++) {
			mids.add(ids.get(i));
		}
	}

	public boolean valid(SystemEnvironment sysEnv, SDMSProxy p)
		throws SDMSException
	{
		try {
			SDMSSubmittedEntity sme = (SDMSSubmittedEntity) p;
			if(mids.contains(sme.getMasterId(sysEnv))) return true;
		} catch (Exception e) { }
		return false;
	}

	public boolean equals(Object o)
	{
		if (o == this) return true;
		if (!(o instanceof MasterIdFilter)) return false;
		MasterIdFilter f;
		f = (MasterIdFilter) o;

		if (mids.size() != f.mids.size()) return false;
		Iterator i = mids.iterator();
		while (i.hasNext())
			if (!f.mids.contains(i.next())) return false;
		return true;
	}
}

