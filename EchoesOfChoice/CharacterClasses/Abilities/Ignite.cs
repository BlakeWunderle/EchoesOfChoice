using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Ignite : Ability
    {
        public Ignite()
        {
            Name = "Ignite";
            FlavorText = "Set an ally's spirit ablaze, amplifying their magical power.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
