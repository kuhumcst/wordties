import psycopg2
import networkx as nx
import sys

conn = psycopg2.connect("dbname=andreord user=andreord")
cur = conn.cursor()

# Uncomment if want to use db relations table in replacement of file input
#cur.execute("SELECT syn_set_id, target_syn_set_id " +
#             "FROM relations r " +
#             "JOIN relation_types rt ON r.relation_type_id = rt.id "
#             "WHERE rt.name = %s ", ('has_hyperonym',))
#resultList = cur.fetchall()
#

# Set imported relations file (csv)
#f=open('/home/seaton/git/andreord-public/lib/import/dan_net_data/relations.csv')
f=open('/home/seaton/git/andreord-public/lib/import/pwn_data/EstWN/EstWNAndreOrd/relations.csv')

G=nx.DiGraph()

for line in f.readlines():
    record = line.split("@")
    if record[2] == 'has_hyperonym':
        source, target = record[0], record[3]
        G.add_edge(target, source)

###################################################
# DanNet error fix - uncomment to use
###################################################
#if nx.is_strongly_connected(G):
#    print "WARNING: Graph is strongly connected"


#for component in nx.strongly_connected_components(G):
#    if len(component) > 1:
#        print component

#G.add_edge('20633', '48174')
#G.add_edge('20633', '48920')

#dangling_nodes = ['8884', '18125']
#G.remove_nodes_from(dangling_nodes)
###################################################


# Note: Update reference to top-most node before using ie {DN:TOP}
#top_node = "20633" # set if top node exists
synset_factor = 1000 # db factoring
top_node = None #str(20633)

def traverse(top_node):
	try:
		for node in nx.traversal.dfs_postorder_nodes(G, top_node):
		    counts = [G.node[succ]['branch_count'] for succ in G.successors(node)] 
		    G.node[node]['branch_count'] = sum(counts) + 1
	except:
		print "Error occurred:", sys.exc_info()[0]
		raise

def update():
	cur = conn.cursor()
	for node in G.nodes():
		db_node = int(node) * synset_factor # Applied synset factoring
		if 'branch_count' not in G.node[node]:
			print "{} is missing branch_count".format(node)
		else:
			sql = ("UPDATE syn_sets SET hyponym_count = %d WHERE id = %d" % (G.node[node]['branch_count'], db_node))
			if not cur.execute(sql):
			    print cur.statusmessage
			    conn.commit()

if top_node == None:
	for target in nx.topological_sort(G):
	    traverse(str(target))
	
	update()
else:
	traverse(top_node)
	update()


