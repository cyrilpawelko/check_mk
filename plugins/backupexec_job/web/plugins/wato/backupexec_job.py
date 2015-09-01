register_check_parameters(
	subgroup_applications,
	"backupexec_job",
	_("Backup Exec Job Status"),
	Dictionary(
		help = _("This check monitors the last result of a Backup Exec Job"),
		elements = [
			("exceptions_are_ok",
				Tuple(
					 title = _("Treat jobs 'completed with exceptions' as OK"),
					 elements = [
				                Checkbox(title = _("'Completed with exceptions' is OK"), default_value = False),
					 ],
				),
			),
 ],
	),
	TextAscii(
		title = _("Job Name"),
		allow_empty = True
	),
	"dict",
)
