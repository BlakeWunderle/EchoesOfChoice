using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Enrage : Ability
    {
        public Enrage()
        {
            Name = "Enrage";
            FlavorText = "Stoke an ally's inner fire, boosting their magic power.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
