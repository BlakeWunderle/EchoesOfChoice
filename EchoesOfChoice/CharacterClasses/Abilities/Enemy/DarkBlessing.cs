using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class DarkBlessing : Ability
    {
        public DarkBlessing()
        {
            Name = "Dark Blessing";
            FlavorText = "A protective ward of twisted forest magic. Increases defenses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
