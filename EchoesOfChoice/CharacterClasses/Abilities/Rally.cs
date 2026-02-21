using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Rally : Ability
    {
        public Rally()
        {
            Name = "Rally";
            FlavorText = "Sound the charge! Increases an ally's speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
            TargetAll = true;
        }
    }
}
