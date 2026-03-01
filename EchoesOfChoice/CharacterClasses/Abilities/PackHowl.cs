using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class PackHowl : Ability
    {
        public PackHowl()
        {
            Name = "Pack Howl";
            FlavorText = "Let out a primal howl that strengthens the entire pack.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
            TargetAll = true;
        }
    }
}
